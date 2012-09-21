Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932726Ab2IUJWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:22:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50094 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab2IUJWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:22:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120921080745.GA2053@core.coreip.homeip.net>
References: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
	<20120921080745.GA2053@core.coreip.homeip.net>
Date: Fri, 21 Sep 2012 11:22:23 +0200
Message-ID: <CANq1E4Q-35oF11Dz6mbNvNYpWYSfOgCXW_E4ZwJ2neZB8p_64w@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] input: Dynamic Minor Numbers
From: David Herrmann <dh.herrmann@googlemail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry

On Fri, Sep 21, 2012 at 10:07 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Thank you very much for working on this, unfortunately your patch extends the
> existing infrastructure handling of character devices in input core,
> which is quite rigid and sub-optimal.
>
> For a while now I wanted to stop input core from pre-creating character
> devices and multiplexing file operations and instead push more chardev
> handling tasks into individual input handlers and make they more
> independent from input core. So while I won't be taking your patch as is
> it was a great motivator to finally do something about current
> limitation and I would appreciate if you could take a look at the patch
> below and see if you have any issues with it.

I didn't know why we did that, anyway. But I tried to keep that logic,
even though it is really weird. So I am quite glad that you fixed it.

> The main difference from your patch:
>
> - switch to cdev infrastructure and creating only devices that actually
>   exist - this simplifies handling of opening non-existing devices as
>   there won't be any;
> - use IDR/IDA framework for tracking minors;

I didn't know of IDR/IDA, that's actually pretty nice.

> - mousedev and joydev also use dynamic minors.

I did never use them so I didn't want to dig into their code. I've
also skipped reviewing them for now. I will try to review them later.

> Thanks!
>
> --
> Dmitry
>
>
> Input: extend the number of event (and other) devices
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> Extend the amount of character devices, such as eventX, mouseX and jsX,
> from a hard limit of 32 per input handler to about 1024 shared across
> all handlers.
>
> To be compatible with legacy installations input handlers will start
> creating char devices with minors in their legacy range, however once
> legacy range is exhausted they will start allocating minors from the
> dynamic range 256-1024.
>
> Because input handlers now do the majority of character devices handling
> and not register their file operations with input core format of
> /proc/bus/input/handlers was changed: "Minor=X" line was taken out.
> With dynamic minors is does not make much sense anyway and nobody was
> ever using it.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>
>  drivers/input/evdev.c    |   99 +++++++-------------
>  drivers/input/input.c    |  114 +++++++++++------------
>  drivers/input/joydev.c   |   88 ++++++------------
>  drivers/input/mousedev.c |  224 ++++++++++++++++++++++++----------------------
>  include/linux/input.h    |    9 +-
>  5 files changed, 237 insertions(+), 297 deletions(-)

If we ignore mousedev, this patch actually reduces line-count. That's
pretty nice!

>
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 6c58bff..0bc4507 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -23,11 +23,11 @@
>  #include <linux/input/mt.h>
>  #include <linux/major.h>
>  #include <linux/device.h>
> +#include <linux/cdev.h>
>  #include "input-compat.h"
>
>  struct evdev {
>         int open;
> -       int minor;
>         struct input_handle handle;
>         wait_queue_head_t wait;
>         struct evdev_client __rcu *grab;
> @@ -35,6 +35,7 @@ struct evdev {
>         spinlock_t client_lock; /* protects client_list */
>         struct mutex mutex;
>         struct device dev;
> +       struct cdev cdev;
>         bool exist;
>  };
>
> @@ -51,9 +52,6 @@ struct evdev_client {
>         struct input_event buffer[];
>  };
>
> -static struct evdev *evdev_table[EVDEV_MINORS];
> -static DEFINE_MUTEX(evdev_table_mutex);
> -
>  static void evdev_pass_event(struct evdev_client *client,
>                              struct input_event *event,
>                              ktime_t mono, ktime_t real)
> @@ -285,35 +283,16 @@ static unsigned int evdev_compute_buffer_size(struct input_dev *dev)
>
>  static int evdev_open(struct inode *inode, struct file *file)
>  {
> -       struct evdev *evdev;
> +       struct evdev *evdev = container_of(inode->i_cdev, struct evdev, cdev);
> +       unsigned int bufsize = evdev_compute_buffer_size(evdev->handle.dev);
>         struct evdev_client *client;
> -       int i = iminor(inode) - EVDEV_MINOR_BASE;
> -       unsigned int bufsize;
>         int error;
>
> -       if (i >= EVDEV_MINORS)
> -               return -ENODEV;
> -
> -       error = mutex_lock_interruptible(&evdev_table_mutex);
> -       if (error)
> -               return error;
> -       evdev = evdev_table[i];
> -       if (evdev)
> -               get_device(&evdev->dev);
> -       mutex_unlock(&evdev_table_mutex);
> -
> -       if (!evdev)
> -               return -ENODEV;
> -
> -       bufsize = evdev_compute_buffer_size(evdev->handle.dev);
> -
>         client = kzalloc(sizeof(struct evdev_client) +
>                                 bufsize * sizeof(struct input_event),
>                          GFP_KERNEL);
> -       if (!client) {
> -               error = -ENOMEM;
> -               goto err_put_evdev;
> -       }
> +       if (!client)
> +               return -ENOMEM;
>
>         client->bufsize = bufsize;
>         spin_lock_init(&client->buffer_lock);
> @@ -327,13 +306,12 @@ static int evdev_open(struct inode *inode, struct file *file)
>         file->private_data = client;
>         nonseekable_open(inode, file);
>
> +       get_device(&evdev->dev);
>         return 0;
>
>   err_free_client:
>         evdev_detach_client(evdev, client);
>         kfree(client);
> - err_put_evdev:
> -       put_device(&evdev->dev);
>         return error;
>  }
>
> @@ -915,26 +893,6 @@ static const struct file_operations evdev_fops = {
>         .llseek         = no_llseek,
>  };
>
> -static int evdev_install_chrdev(struct evdev *evdev)
> -{
> -       /*
> -        * No need to do any locking here as calls to connect and
> -        * disconnect are serialized by the input core
> -        */
> -       evdev_table[evdev->minor] = evdev;
> -       return 0;
> -}
> -
> -static void evdev_remove_chrdev(struct evdev *evdev)
> -{
> -       /*
> -        * Lock evdev table to prevent race with evdev_open()
> -        */
> -       mutex_lock(&evdev_table_mutex);
> -       evdev_table[evdev->minor] = NULL;
> -       mutex_unlock(&evdev_table_mutex);
> -}
> -
>  /*
>   * Mark device non-existent. This disables writes, ioctls and
>   * prevents new users from opening the device. Already posted
> @@ -953,7 +911,8 @@ static void evdev_cleanup(struct evdev *evdev)
>
>         evdev_mark_dead(evdev);
>         evdev_hangup(evdev);
> -       evdev_remove_chrdev(evdev);
> +
> +       cdev_del(&evdev->cdev);
>
>         /* evdev is marked dead so no one else accesses evdev->open */
>         if (evdev->open) {
> @@ -964,43 +923,47 @@ static void evdev_cleanup(struct evdev *evdev)
>
>  /*
>   * Create new evdev device. Note that input core serializes calls
> - * to connect and disconnect so we don't need to lock evdev_table here.
> + * to connect and disconnect.
>   */
>  static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>                          const struct input_device_id *id)
>  {
>         struct evdev *evdev;
>         int minor;
> +       int dev_no;
>         int error;
>
> -       for (minor = 0; minor < EVDEV_MINORS; minor++)
> -               if (!evdev_table[minor])
> -                       break;
> -
> -       if (minor == EVDEV_MINORS) {
> -               pr_err("no more free evdev devices\n");
> -               return -ENFILE;
> +       minor = input_get_new_minor(EVDEV_MINOR_BASE, 8 /*EVDEV_MINORS*/, true);

Why 8 instead of EVDEV_MINORS?

> +       if (minor < 0) {
> +               error = minor;
> +               pr_err("failed to reserve new minor: %d\n", error);
> +               return error;
>         }
>
>         evdev = kzalloc(sizeof(struct evdev), GFP_KERNEL);
> -       if (!evdev)
> -               return -ENOMEM;
> +       if (!evdev) {
> +               error = -ENOMEM;
> +               goto err_free_minor;
> +       }
>
>         INIT_LIST_HEAD(&evdev->client_list);
>         spin_lock_init(&evdev->client_lock);
>         mutex_init(&evdev->mutex);
>         init_waitqueue_head(&evdev->wait);
> -
> -       dev_set_name(&evdev->dev, "event%d", minor);
>         evdev->exist = true;
> -       evdev->minor = minor;
> +
> +       dev_no = minor;
> +       /* Normalize device number if it falls into legacy range */
> +       if (dev_no < EVDEV_MINOR_BASE + EVDEV_MINORS)
> +               dev_no -= EVDEV_MINOR_BASE;
> +       dev_set_name(&evdev->dev, "event%d", dev_no);
>
>         evdev->handle.dev = input_get_device(dev);
>         evdev->handle.name = dev_name(&evdev->dev);
>         evdev->handle.handler = handler;
>         evdev->handle.private = evdev;
>
> -       evdev->dev.devt = MKDEV(INPUT_MAJOR, EVDEV_MINOR_BASE + minor);
> +       evdev->dev.devt = MKDEV(INPUT_MAJOR, minor);
>         evdev->dev.class = &input_class;
>         evdev->dev.parent = &dev->dev;
>         evdev->dev.release = evdev_free;
> @@ -1010,7 +973,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>         if (error)
>                 goto err_free_evdev;
>
> -       error = evdev_install_chrdev(evdev);
> +       cdev_init(&evdev->cdev, &evdev_fops);
> +       error = cdev_add(&evdev->cdev, evdev->dev.devt, 1);
>         if (error)
>                 goto err_unregister_handle;
>
> @@ -1026,6 +990,8 @@ static int evdev_connect(struct input_handler *handler, struct input_dev *dev,
>         input_unregister_handle(&evdev->handle);
>   err_free_evdev:
>         put_device(&evdev->dev);
> + err_free_minor:
> +       input_free_minor(minor);
>         return error;
>  }
>
> @@ -1035,6 +1001,7 @@ static void evdev_disconnect(struct input_handle *handle)
>
>         device_del(&evdev->dev);
>         evdev_cleanup(evdev);
> +       input_free_minor(MINOR(evdev->dev.devt));
>         input_unregister_handle(handle);
>         put_device(&evdev->dev);
>  }
> @@ -1050,8 +1017,6 @@ static struct input_handler evdev_handler = {
>         .event          = evdev_event,
>         .connect        = evdev_connect,
>         .disconnect     = evdev_disconnect,
> -       .fops           = &evdev_fops,
> -       .minor          = EVDEV_MINOR_BASE,
>         .name           = "evdev",
>         .id_table       = evdev_ids,
>  };
> diff --git a/drivers/input/input.c b/drivers/input/input.c
> index 768e46b..1869cf1 100644
> --- a/drivers/input/input.c
> +++ b/drivers/input/input.c
> @@ -14,6 +14,7 @@
>
>  #include <linux/init.h>
>  #include <linux/types.h>
> +#include <linux/idr.h>
>  #include <linux/input/mt.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> @@ -32,7 +33,9 @@ MODULE_AUTHOR("Vojtech Pavlik <vojtech@suse.cz>");
>  MODULE_DESCRIPTION("Input core");
>  MODULE_LICENSE("GPL");
>
> -#define INPUT_DEVICES  256
> +#define INPUT_MAX_CHAR_DEVICES         1024
> +#define INPUT_FIRST_DYNAMIC_DEV                256

Maybe we should have some comment which explains that there were
historically 8 statically assigned blocks of 32 minors here. Moreover,
I think we can actually decrease that value, can't we? I think only 3
blocks were really used so using EVDEV_MINOR_BASE+32 = 96 would avoid
allocating a "huge" unused range in the IDA/IDR array.

> +static DEFINE_IDA(input_ida);
>
>  static LIST_HEAD(input_dev_list);
>  static LIST_HEAD(input_handler_list);
> @@ -45,8 +48,6 @@ static LIST_HEAD(input_handler_list);
>   */
>  static DEFINE_MUTEX(input_mutex);
>
> -static struct input_handler *input_table[8];
> -
>  static inline int is_event_supported(unsigned int code,
>                                      unsigned long *bm, unsigned int max)
>  {
> @@ -1144,8 +1145,6 @@ static int input_handlers_seq_show(struct seq_file *seq, void *v)
>         seq_printf(seq, "N: Number=%u Name=%s", state->pos, handler->name);
>         if (handler->filter)
>                 seq_puts(seq, " (filter)");
> -       if (handler->fops)
> -               seq_printf(seq, " Minor=%d", handler->minor);

This actually breaks ABI. Can't we put this into a separate patch
which is applied before this one so if someone does bisect this, they
will get a shorter commit than this one with a clear statement in the
commit message?

>         seq_putc(seq, '\n');
>
>         return 0;
> @@ -1932,22 +1931,14 @@ EXPORT_SYMBOL(input_unregister_device);
>  int input_register_handler(struct input_handler *handler)
>  {
>         struct input_dev *dev;
> -       int retval;
> +       int error;
>
> -       retval = mutex_lock_interruptible(&input_mutex);
> -       if (retval)
> -               return retval;
> +       error = mutex_lock_interruptible(&input_mutex);
> +       if (error)
> +               return error;

Why do you rename the variable here? It's actually just adding noise
to the still really long patch.

>         INIT_LIST_HEAD(&handler->h_list);
>
> -       if (handler->fops != NULL) {
> -               if (input_table[handler->minor >> 5]) {
> -                       retval = -EBUSY;
> -                       goto out;
> -               }
> -               input_table[handler->minor >> 5] = handler;
> -       }
> -
>         list_add_tail(&handler->node, &input_handler_list);
>
>         list_for_each_entry(dev, &input_dev_list, node)
> @@ -1955,9 +1946,8 @@ int input_register_handler(struct input_handler *handler)
>
>         input_wakeup_procfs_readers();
>
> - out:
>         mutex_unlock(&input_mutex);
> -       return retval;
> +       return 0;
>  }
>  EXPORT_SYMBOL(input_register_handler);
>
> @@ -1980,9 +1970,6 @@ void input_unregister_handler(struct input_handler *handler)
>
>         list_del_init(&handler->node);
>
> -       if (handler->fops != NULL)
> -               input_table[handler->minor >> 5] = NULL;
> -
>         input_wakeup_procfs_readers();
>
>         mutex_unlock(&input_mutex);
> @@ -2099,51 +2086,52 @@ void input_unregister_handle(struct input_handle *handle)
>  }
>  EXPORT_SYMBOL(input_unregister_handle);
>
> -static int input_open_file(struct inode *inode, struct file *file)
> +/**
> + * input_get_new_minor - allocates a new input minor number
> + * @legacy_base: beginning or the legacy range to be searched

"... or -1 if not available" or something like that.

> + * @legacy_num: size of legacy range
> + * @allow_dynamic: whether we can also take ID from the dynamic range
> + *
> + * This function allocates a new device minor for from input major namespace.
> + * Caller can request legacy minor by specifying @legacy_base and @legacy_num
> + * parameters and whether ID can be allocated from dynamic range if there are
> + * no free IDs in legacy range.
> + */
> +int input_get_new_minor(int legacy_base, unsigned int legacy_num,
> +                       bool allow_dynamic)
>  {
> -       struct input_handler *handler;
> -       const struct file_operations *old_fops, *new_fops = NULL;
> -       int err;
> -
> -       err = mutex_lock_interruptible(&input_mutex);
> -       if (err)
> -               return err;
> -
> -       /* No load-on-demand here? */
> -       handler = input_table[iminor(inode) >> 5];
> -       if (handler)
> -               new_fops = fops_get(handler->fops);
> -
> -       mutex_unlock(&input_mutex);
> -
>         /*
> -        * That's _really_ odd. Usually NULL ->open means "nothing special",
> -        * not "no device". Oh, well...
> +        * This function should be called from input handler's ->connect()
> +        * methods, which are serialized with input_mutex, so no additional
> +        * locking is needed here.
>          */
> -       if (!new_fops || !new_fops->open) {
> -               fops_put(new_fops);
> -               err = -ENODEV;
> -               goto out;
> +       if (legacy_base >= 0) {
> +               int minor = ida_simple_get(&input_ida,
> +                                          legacy_base,
> +                                          legacy_base + legacy_num,
> +                                          GFP_KERNEL);
> +               if (minor >= 0 || !allow_dynamic)
> +                       return minor;
>         }
>
> -       old_fops = file->f_op;
> -       file->f_op = new_fops;
> -
> -       err = new_fops->open(inode, file);
> -       if (err) {
> -               fops_put(file->f_op);
> -               file->f_op = fops_get(old_fops);
> -       }
> -       fops_put(old_fops);
> -out:
> -       return err;
> +       return ida_simple_get(&input_ida,
> +                             INPUT_FIRST_DYNAMIC_DEV, INPUT_MAX_CHAR_DEVICES,
> +                             GFP_KERNEL);
>  }
> +EXPORT_SYMBOL(input_get_new_minor);
>
> -static const struct file_operations input_fops = {
> -       .owner = THIS_MODULE,
> -       .open = input_open_file,
> -       .llseek = noop_llseek,
> -};
> +/**
> + * input_free_minor - release previously allocated minor
> + * @minor: minor to be released
> + *
> + * This function releases previously allocated input minor so that it can be
> + * reused later.
> + */
> +void input_free_minor(unsigned int minor)
> +{
> +       ida_simple_remove(&input_ida, minor);
> +}
> +EXPORT_SYMBOL(input_free_minor);
>
>  static int __init input_init(void)
>  {
> @@ -2159,7 +2147,8 @@ static int __init input_init(void)
>         if (err)
>                 goto fail1;
>
> -       err = register_chrdev(INPUT_MAJOR, "input", &input_fops);
> +       err = register_chrdev_region(MKDEV(INPUT_MAJOR, 0),
> +                                    INPUT_MAX_CHAR_DEVICES, "input");
>         if (err) {
>                 pr_err("unable to register char major %d", INPUT_MAJOR);
>                 goto fail2;
> @@ -2175,7 +2164,8 @@ static int __init input_init(void)
>  static void __exit input_exit(void)
>  {
>         input_proc_exit();
> -       unregister_chrdev(INPUT_MAJOR, "input");
> +       unregister_chrdev_region(MKDEV(INPUT_MAJOR, 0),
> +                                INPUT_MAX_CHAR_DEVICES);
>         class_unregister(&input_class);
>  }

I haven't actually tested it, yet, but I will give it a try later this
weekend (and also review the rest of it). But it looks definitely
nicer than my approach. Thanks! I also didn't find any races with
evdev.cdev and evdev.dev.
The user-space semantics are the same as with my patch. That's nice, too.

Thanks a lot! Maybe we can even get this into 3.7?
Regards
David
