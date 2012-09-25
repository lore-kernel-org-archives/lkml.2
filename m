Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2IYIzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 04:55:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39016 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab2IYIzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 04:55:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120921080745.GA2053@core.coreip.homeip.net>
References: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
	<20120921080745.GA2053@core.coreip.homeip.net>
Date: Tue, 25 Sep 2012 10:55:34 +0200
Message-ID: <CANq1E4TLXoB--fH3zF425gTukqUh+kAgOmhB0+wGEM0krFB=-A@mail.gmail.com>
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

[snip] See my previous review

> diff --git a/drivers/input/joydev.c b/drivers/input/joydev.c
> index f0909ed..c82f76f 100644
> --- a/drivers/input/joydev.c
> +++ b/drivers/input/joydev.c
> @@ -27,6 +27,7 @@
>  #include <linux/poll.h>
>  #include <linux/init.h>
>  #include <linux/device.h>
> +#include <linux/cdev.h>
>
>  MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
>  MODULE_DESCRIPTION("Joystick device interfaces");
> @@ -39,13 +40,13 @@ MODULE_LICENSE("GPL");
>
>  struct joydev {
>         int open;
> -       int minor;
>         struct input_handle handle;
>         wait_queue_head_t wait;
>         struct list_head client_list;
>         spinlock_t client_lock; /* protects client_list */
>         struct mutex mutex;
>         struct device dev;
> +       struct cdev cdev;
>         bool exist;
>
>         struct js_corr corr[ABS_CNT];
> @@ -70,9 +71,6 @@ struct joydev_client {
>         struct list_head node;
>  };
>
> -static struct joydev *joydev_table[JOYDEV_MINORS];
> -static DEFINE_MUTEX(joydev_table_mutex);
> -
>  static int joydev_correct(int value, struct js_corr *corr)
>  {
>         switch (corr->type) {
> @@ -252,30 +250,14 @@ static int joydev_release(struct inode *inode, struct file *file)
>
>  static int joydev_open(struct inode *inode, struct file *file)
>  {
> +       struct joydev *joydev =
> +                       container_of(inode->i_cdev, struct joydev, cdev);
>         struct joydev_client *client;
> -       struct joydev *joydev;
> -       int i = iminor(inode) - JOYDEV_MINOR_BASE;
>         int error;
>
> -       if (i >= JOYDEV_MINORS)
> -               return -ENODEV;
> -
> -       error = mutex_lock_interruptible(&joydev_table_mutex);
> -       if (error)
> -               return error;
> -       joydev = joydev_table[i];
> -       if (joydev)
> -               get_device(&joydev->dev);
> -       mutex_unlock(&joydev_table_mutex);
> -
> -       if (!joydev)
> -               return -ENODEV;
> -
>         client = kzalloc(sizeof(struct joydev_client), GFP_KERNEL);
> -       if (!client) {
> -               error = -ENOMEM;
> -               goto err_put_joydev;
> -       }
> +       if (!client)
> +               return -ENOMEM;
>
>         spin_lock_init(&client->buffer_lock);
>         client->joydev = joydev;
> @@ -288,13 +270,12 @@ static int joydev_open(struct inode *inode, struct file *file)
>         file->private_data = client;
>         nonseekable_open(inode, file);
>
> +       get_device(&joydev->dev);
>         return 0;
>
>   err_free_client:
>         joydev_detach_client(joydev, client);
>         kfree(client);
> - err_put_joydev:
> -       put_device(&joydev->dev);
>         return error;
>  }
>
> @@ -747,19 +728,6 @@ static const struct file_operations joydev_fops = {
>         .llseek         = no_llseek,
>  };
>
> -static int joydev_install_chrdev(struct joydev *joydev)
> -{
> -       joydev_table[joydev->minor] = joydev;
> -       return 0;
> -}
> -
> -static void joydev_remove_chrdev(struct joydev *joydev)
> -{
> -       mutex_lock(&joydev_table_mutex);
> -       joydev_table[joydev->minor] = NULL;
> -       mutex_unlock(&joydev_table_mutex);
> -}
> -
>  /*
>   * Mark device non-existent. This disables writes, ioctls and
>   * prevents new users from opening the device. Already posted
> @@ -778,7 +746,8 @@ static void joydev_cleanup(struct joydev *joydev)
>
>         joydev_mark_dead(joydev);
>         joydev_hangup(joydev);
> -       joydev_remove_chrdev(joydev);
> +
> +       cdev_del(&joydev->cdev);
>
>         /* joydev is marked dead so no one else accesses joydev->open */
>         if (joydev->open)
> @@ -803,30 +772,33 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>                           const struct input_device_id *id)
>  {
>         struct joydev *joydev;
> -       int i, j, t, minor;
> +       int i, j, t, minor, dev_no;
>         int error;
>
> -       for (minor = 0; minor < JOYDEV_MINORS; minor++)
> -               if (!joydev_table[minor])
> -                       break;
> -
> -       if (minor == JOYDEV_MINORS) {
> -               pr_err("no more free joydev devices\n");
> -               return -ENFILE;
> +       minor = input_get_new_minor(JOYDEV_MINOR_BASE, JOYDEV_MINORS, true);
> +       if (minor < 0) {
> +               error = minor;
> +               pr_err("failed to reserve new minor: %d\n", error);
> +               return error;

How about:
  return minor;
and avoid the "error = minor;" line?

>         }
>
>         joydev = kzalloc(sizeof(struct joydev), GFP_KERNEL);
> -       if (!joydev)
> -               return -ENOMEM;
> +       if (!joydev) {
> +               error = -ENOMEM;
> +               goto err_free_minor;
> +       }
>
>         INIT_LIST_HEAD(&joydev->client_list);
>         spin_lock_init(&joydev->client_lock);
>         mutex_init(&joydev->mutex);
>         init_waitqueue_head(&joydev->wait);
> -
> -       dev_set_name(&joydev->dev, "js%d", minor);
>         joydev->exist = true;
> -       joydev->minor = minor;
> +
> +       dev_no = minor;
> +       /* Normalize device number if it falls into legacy range */
> +       if (dev_no < JOYDEV_MINOR_BASE + JOYDEV_MINORS)
> +               dev_no -= JOYDEV_MINOR_BASE;
> +       dev_set_name(&joydev->dev, "js%d", dev_no);
>
>         joydev->handle.dev = input_get_device(dev);
>         joydev->handle.name = dev_name(&joydev->dev);
> @@ -880,7 +852,7 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>                 }
>         }
>
> -       joydev->dev.devt = MKDEV(INPUT_MAJOR, JOYDEV_MINOR_BASE + minor);
> +       joydev->dev.devt = MKDEV(INPUT_MAJOR, minor);
>         joydev->dev.class = &input_class;
>         joydev->dev.parent = &dev->dev;
>         joydev->dev.release = joydev_free;
> @@ -890,7 +862,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>         if (error)
>                 goto err_free_joydev;
>
> -       error = joydev_install_chrdev(joydev);
> +       cdev_init(&joydev->cdev, &joydev_fops);
> +       error = cdev_add(&joydev->cdev, joydev->dev.devt, 1);
>         if (error)
>                 goto err_unregister_handle;
>
> @@ -906,6 +879,8 @@ static int joydev_connect(struct input_handler *handler, struct input_dev *dev,
>         input_unregister_handle(&joydev->handle);
>   err_free_joydev:
>         put_device(&joydev->dev);
> + err_free_minor:
> +       input_free_minor(minor);
>         return error;
>  }
>
> @@ -915,6 +890,7 @@ static void joydev_disconnect(struct input_handle *handle)
>
>         device_del(&joydev->dev);
>         joydev_cleanup(joydev);
> +       input_free_minor(MINOR(joydev->dev.devt));
>         input_unregister_handle(handle);
>         put_device(&joydev->dev);
>  }
> @@ -966,8 +942,6 @@ static struct input_handler joydev_handler = {
>         .match          = joydev_match,
>         .connect        = joydev_connect,
>         .disconnect     = joydev_disconnect,
> -       .fops           = &joydev_fops,
> -       .minor          = JOYDEV_MINOR_BASE,
>         .name           = "joydev",
>         .id_table       = joydev_ids,
>  };
> diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
> index 964e43d..7fd9d91 100644
> --- a/drivers/input/mousedev.c
> +++ b/drivers/input/mousedev.c
> @@ -24,10 +24,8 @@
>  #include <linux/random.h>
>  #include <linux/major.h>
>  #include <linux/device.h>
> +#include <linux/cdev.h>
>  #include <linux/kernel.h>
> -#ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
> -#include <linux/miscdevice.h>
> -#endif
>
>  MODULE_AUTHOR("Vojtech Pavlik <vojtech@ucw.cz>");
>  MODULE_DESCRIPTION("Mouse (ExplorerPS/2) device interfaces");
> @@ -61,17 +59,18 @@ struct mousedev_hw_data {
>
>  struct mousedev {
>         int open;
> -       int minor;
>         struct input_handle handle;
>         wait_queue_head_t wait;
>         struct list_head client_list;
>         spinlock_t client_lock; /* protects client_list */
>         struct mutex mutex;
>         struct device dev;
> +       struct cdev cdev;
>         bool exist;
> +       bool is_mixdev;
>
>         struct list_head mixdev_node;
> -       int mixdev_open;
> +       bool mixdev_open;

Could you keep cleanup/codingstyle-patches separate? It makes review
so much easier. This patch is already quite long. Anyway, looks good.

>
>         struct mousedev_hw_data packet;
>         unsigned int pkt_count;
> @@ -114,10 +113,6 @@ struct mousedev_client {
>  static unsigned char mousedev_imps_seq[] = { 0xf3, 200, 0xf3, 100, 0xf3, 80 };
>  static unsigned char mousedev_imex_seq[] = { 0xf3, 200, 0xf3, 200, 0xf3, 80 };
>
> -static struct input_handler mousedev_handler;
> -
> -static struct mousedev *mousedev_table[MOUSEDEV_MINORS];
> -static DEFINE_MUTEX(mousedev_table_mutex);
>  static struct mousedev *mousedev_mix;
>  static LIST_HEAD(mousedev_mix_list);
>
> @@ -433,7 +428,7 @@ static int mousedev_open_device(struct mousedev *mousedev)
>         if (retval)
>                 return retval;
>
> -       if (mousedev->minor == MOUSEDEV_MIX)
> +       if (mousedev->is_mixdev)
>                 mixdev_open_devices();
>         else if (!mousedev->exist)
>                 retval = -ENODEV;
> @@ -451,7 +446,7 @@ static void mousedev_close_device(struct mousedev *mousedev)
>  {
>         mutex_lock(&mousedev->mutex);
>
> -       if (mousedev->minor == MOUSEDEV_MIX)
> +       if (mousedev->is_mixdev)
>                 mixdev_close_devices();
>         else if (mousedev->exist && !--mousedev->open)
>                 input_close_device(&mousedev->handle);
> @@ -476,7 +471,7 @@ static void mixdev_open_devices(void)
>                         if (mousedev_open_device(mousedev))
>                                 continue;
>
> -                       mousedev->mixdev_open = 1;
> +                       mousedev->mixdev_open = true;
>                 }
>         }
>  }
> @@ -495,7 +490,7 @@ static void mixdev_close_devices(void)
>
>         list_for_each_entry(mousedev, &mousedev_mix_list, mixdev_node) {
>                 if (mousedev->mixdev_open) {
> -                       mousedev->mixdev_open = 0;
> +                       mousedev->mixdev_open = false;
>                         mousedev_close_device(mousedev);
>                 }
>         }
> @@ -538,35 +533,17 @@ static int mousedev_open(struct inode *inode, struct file *file)
>         struct mousedev_client *client;
>         struct mousedev *mousedev;
>         int error;
> -       int i;
>
>  #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
>         if (imajor(inode) == MISC_MAJOR)
> -               i = MOUSEDEV_MIX;
> +               mousedev = mousedev_mix;
>         else
>  #endif
> -               i = iminor(inode) - MOUSEDEV_MINOR_BASE;
> -
> -       if (i >= MOUSEDEV_MINORS)
> -               return -ENODEV;
> -
> -       error = mutex_lock_interruptible(&mousedev_table_mutex);
> -       if (error)
> -               return error;
> -
> -       mousedev = mousedev_table[i];
> -       if (mousedev)
> -               get_device(&mousedev->dev);
> -       mutex_unlock(&mousedev_table_mutex);
> -
> -       if (!mousedev)
> -               return -ENODEV;
> +               mousedev = container_of(inode->i_cdev, struct mousedev, cdev);
>
>         client = kzalloc(sizeof(struct mousedev_client), GFP_KERNEL);
> -       if (!client) {
> -               error = -ENOMEM;
> -               goto err_put_mousedev;
> -       }
> +       if (!client)
> +               return -ENOMEM;
>
>         spin_lock_init(&client->packet_lock);
>         client->pos_x = xres / 2;
> @@ -579,13 +556,14 @@ static int mousedev_open(struct inode *inode, struct file *file)
>                 goto err_free_client;
>
>         file->private_data = client;
> +       nonseekable_open(inode, file);
> +
> +       get_device(&mousedev->dev);
>         return 0;
>
>   err_free_client:
>         mousedev_detach_client(mousedev, client);
>         kfree(client);
> - err_put_mousedev:
> -       put_device(&mousedev->dev);
>         return error;
>  }
>
> @@ -785,29 +763,16 @@ static unsigned int mousedev_poll(struct file *file, poll_table *wait)
>  }
>
>  static const struct file_operations mousedev_fops = {
> -       .owner =        THIS_MODULE,
> -       .read =         mousedev_read,
> -       .write =        mousedev_write,
> -       .poll =         mousedev_poll,
> -       .open =         mousedev_open,
> -       .release =      mousedev_release,
> -       .fasync =       mousedev_fasync,
> -       .llseek = noop_llseek,
> +       .owner          = THIS_MODULE,
> +       .read           = mousedev_read,
> +       .write          = mousedev_write,
> +       .poll           = mousedev_poll,
> +       .open           = mousedev_open,
> +       .release        = mousedev_release,
> +       .fasync         = mousedev_fasync,
> +       .llseek         = noop_llseek,
>  };

Again some cleanups.

> -static int mousedev_install_chrdev(struct mousedev *mousedev)
> -{
> -       mousedev_table[mousedev->minor] = mousedev;
> -       return 0;
> -}
> -
> -static void mousedev_remove_chrdev(struct mousedev *mousedev)
> -{
> -       mutex_lock(&mousedev_table_mutex);
> -       mousedev_table[mousedev->minor] = NULL;
> -       mutex_unlock(&mousedev_table_mutex);
> -}
> -
>  /*
>   * Mark device non-existent. This disables writes, ioctls and
>   * prevents new users from opening the device. Already posted
> @@ -842,24 +807,50 @@ static void mousedev_cleanup(struct mousedev *mousedev)
>
>         mousedev_mark_dead(mousedev);
>         mousedev_hangup(mousedev);
> -       mousedev_remove_chrdev(mousedev);
> +
> +       cdev_del(&mousedev->cdev);
>
>         /* mousedev is marked dead so no one else accesses mousedev->open */
>         if (mousedev->open)
>                 input_close_device(handle);
>  }
>
> +static int mousedev_reserve_minor(bool mixdev)
> +{
> +       int minor;
> +
> +       if (mixdev) {
> +               minor = input_get_new_minor(MOUSEDEV_MIX, 1, false);
> +               if (minor < 0)
> +                       pr_err("failed to reserve mixdev minor: %d\n", minor);
> +       } else {
> +               minor = input_get_new_minor(MOUSEDEV_MINOR_BASE,
> +                                           MOUSEDEV_MINORS, true);
> +               if (minor < 0)
> +                       pr_err("failed to reserve new minor: %d\n", minor);
> +       }
> +
> +       return minor;
> +}
> +
>  static struct mousedev *mousedev_create(struct input_dev *dev,
>                                         struct input_handler *handler,
> -                                       int minor)
> +                                       bool mixdev)
>  {
>         struct mousedev *mousedev;
> +       int minor;
>         int error;
>
> +       minor = mousedev_reserve_minor(mixdev);
> +       if (minor < 0) {
> +               error = minor;
> +               goto err_out;
> +       }
> +
>         mousedev = kzalloc(sizeof(struct mousedev), GFP_KERNEL);
>         if (!mousedev) {
>                 error = -ENOMEM;
> -               goto err_out;
> +               goto err_free_minor;
>         }
>
>         INIT_LIST_HEAD(&mousedev->client_list);
> @@ -867,16 +858,21 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>         spin_lock_init(&mousedev->client_lock);
>         mutex_init(&mousedev->mutex);
>         lockdep_set_subclass(&mousedev->mutex,
> -                            minor == MOUSEDEV_MIX ? SINGLE_DEPTH_NESTING : 0);
> +                            mixdev ? SINGLE_DEPTH_NESTING : 0);
>         init_waitqueue_head(&mousedev->wait);
>
> -       if (minor == MOUSEDEV_MIX)
> +       if (mixdev) {
>                 dev_set_name(&mousedev->dev, "mice");
> -       else
> -               dev_set_name(&mousedev->dev, "mouse%d", minor);
> +       } else {
> +               int dev_no = minor;
> +               /* Normalize device number if it falls into legacy range */
> +               if (dev_no < MOUSEDEV_MINOR_BASE + MOUSEDEV_MINORS)
> +                       dev_no -= MOUSEDEV_MINOR_BASE;
> +               dev_set_name(&mousedev->dev, "mouse%d", dev_no);
> +       }
>
> -       mousedev->minor = minor;
>         mousedev->exist = true;
> +       mousedev->is_mixdev = mixdev;
>         mousedev->handle.dev = input_get_device(dev);
>         mousedev->handle.name = dev_name(&mousedev->dev);
>         mousedev->handle.handler = handler;
> @@ -885,17 +881,18 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>         mousedev->dev.class = &input_class;
>         if (dev)
>                 mousedev->dev.parent = &dev->dev;
> -       mousedev->dev.devt = MKDEV(INPUT_MAJOR, MOUSEDEV_MINOR_BASE + minor);
> +       mousedev->dev.devt = MKDEV(INPUT_MAJOR, minor);
>         mousedev->dev.release = mousedev_free;
>         device_initialize(&mousedev->dev);
>
> -       if (minor != MOUSEDEV_MIX) {
> +       if (!mixdev) {
>                 error = input_register_handle(&mousedev->handle);
>                 if (error)
>                         goto err_free_mousedev;
>         }
>
> -       error = mousedev_install_chrdev(mousedev);
> +       cdev_init(&mousedev->cdev, &mousedev_fops);
> +       error = cdev_add(&mousedev->cdev, mousedev->dev.devt, 1);
>         if (error)
>                 goto err_unregister_handle;
>
> @@ -908,10 +905,12 @@ static struct mousedev *mousedev_create(struct input_dev *dev,
>   err_cleanup_mousedev:
>         mousedev_cleanup(mousedev);
>   err_unregister_handle:
> -       if (minor != MOUSEDEV_MIX)
> +       if (!mixdev)
>                 input_unregister_handle(&mousedev->handle);
>   err_free_mousedev:
>         put_device(&mousedev->dev);
> + err_free_minor:
> +       input_free_minor(minor);
>   err_out:
>         return ERR_PTR(error);
>  }
> @@ -920,7 +919,8 @@ static void mousedev_destroy(struct mousedev *mousedev)
>  {
>         device_del(&mousedev->dev);
>         mousedev_cleanup(mousedev);
> -       if (mousedev->minor != MOUSEDEV_MIX)
> +       input_free_minor(MINOR(mousedev->dev.devt));
> +       if (!mousedev->is_mixdev)
>                 input_unregister_handle(&mousedev->handle);
>         put_device(&mousedev->dev);
>  }
> @@ -938,7 +938,7 @@ static int mixdev_add_device(struct mousedev *mousedev)
>                 if (retval)
>                         goto out;
>
> -               mousedev->mixdev_open = 1;
> +               mousedev->mixdev_open = true;
>         }
>
>         get_device(&mousedev->dev);
> @@ -954,7 +954,7 @@ static void mixdev_remove_device(struct mousedev *mousedev)
>         mutex_lock(&mousedev_mix->mutex);
>
>         if (mousedev->mixdev_open) {
> -               mousedev->mixdev_open = 0;
> +               mousedev->mixdev_open = false;
>                 mousedev_close_device(mousedev);
>         }
>
> @@ -969,19 +969,9 @@ static int mousedev_connect(struct input_handler *handler,
>                             const struct input_device_id *id)
>  {
>         struct mousedev *mousedev;
> -       int minor;
>         int error;
>
> -       for (minor = 0; minor < MOUSEDEV_MINORS; minor++)
> -               if (!mousedev_table[minor])
> -                       break;
> -
> -       if (minor == MOUSEDEV_MINORS) {
> -               pr_err("no more free mousedev devices\n");
> -               return -ENFILE;
> -       }
> -
> -       mousedev = mousedev_create(dev, handler, minor);
> +       mousedev = mousedev_create(dev, handler, false);
>         if (IS_ERR(mousedev))
>                 return PTR_ERR(mousedev);
>
> @@ -1054,27 +1044,59 @@ static const struct input_device_id mousedev_ids[] = {
>  MODULE_DEVICE_TABLE(input, mousedev_ids);
>
>  static struct input_handler mousedev_handler = {
> -       .event =        mousedev_event,
> -       .connect =      mousedev_connect,
> -       .disconnect =   mousedev_disconnect,
> -       .fops =         &mousedev_fops,
> -       .minor =        MOUSEDEV_MINOR_BASE,
> -       .name =         "mousedev",
> -       .id_table =     mousedev_ids,
> +       .event          = mousedev_event,
> +       .connect        = mousedev_connect,
> +       .disconnect     = mousedev_disconnect,
> +       .name           = "mousedev",
> +       .id_table       = mousedev_ids,
>  };
>
>  #ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
> +#include <linux/miscdevice.h>
> +
>  static struct miscdevice psaux_mouse = {
> -       PSMOUSE_MINOR, "psaux", &mousedev_fops
> +       .minor  = PSMOUSE_MINOR,
> +       .name   = "psaux",
> +       .fops   = &mousedev_fops,
>  };
> -static int psaux_registered;
> +static bool psaux_registered;
> +
> +static void __init mousedev_psaux_register(void)
> +{
> +       int error;
> +
> +       error = misc_register(&psaux_mouse);
> +       if (error)
> +               pr_warn("could not register psaux device, error: %d\n",
> +                          error);
> +       else
> +               psaux_registered = true;
> +

Why that newline here?

> +}
> +
> +static void __exit mousedev_psaux_unregister(void)
> +{
> +       if (psaux_registered)
> +               misc_deregister(&psaux_mouse);
> +}
> +
> +#else
> +
> +static inline void mousedev_psaux_register(void)
> +{
> +}
> +
> +static inline void mousedev_psaux_unregister(void)
> +{
> +}
> +
>  #endif
>
>  static int __init mousedev_init(void)
>  {
>         int error;
>
> -       mousedev_mix = mousedev_create(NULL, &mousedev_handler, MOUSEDEV_MIX);
> +       mousedev_mix = mousedev_create(NULL, &mousedev_handler, true);
>         if (IS_ERR(mousedev_mix))
>                 return PTR_ERR(mousedev_mix);
>
> @@ -1084,14 +1106,7 @@ static int __init mousedev_init(void)
>                 return error;
>         }
>
> -#ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
> -       error = misc_register(&psaux_mouse);
> -       if (error)
> -               pr_warn("could not register psaux device, error: %d\n",
> -                          error);
> -       else
> -               psaux_registered = 1;
> -#endif
> +       mousedev_psaux_register();
>
>         pr_info("PS/2 mouse device common for all mice\n");
>
> @@ -1100,10 +1115,7 @@ static int __init mousedev_init(void)
>
>  static void __exit mousedev_exit(void)
>  {
> -#ifdef CONFIG_INPUT_MOUSEDEV_PSAUX
> -       if (psaux_registered)
> -               misc_deregister(&psaux_mouse);
> -#endif
> +       mousedev_psaux_unregister();
>         input_unregister_handler(&mousedev_handler);
>         mousedev_destroy(mousedev_mix);
>  }
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 725dcd0..c698e7e 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -1387,9 +1387,6 @@ struct input_handle;
>   * @start: starts handler for given handle. This function is called by
>   *     input core right after connect() method and also when a process
>   *     that "grabbed" a device releases it
> - * @fops: file operations this driver implements
> - * @minor: beginning of range of 32 minors for devices this driver
> - *     can provide
>   * @name: name of the handler, to be shown in /proc/bus/input/handlers
>   * @id_table: pointer to a table of input_device_ids this driver can
>   *     handle
> @@ -1420,8 +1417,6 @@ struct input_handler {
>         void (*disconnect)(struct input_handle *handle);
>         void (*start)(struct input_handle *handle);
>
> -       const struct file_operations *fops;
> -       int minor;
>         const char *name;
>
>         const struct input_device_id *id_table;
> @@ -1488,6 +1483,10 @@ void input_reset_device(struct input_dev *);
>  int __must_check input_register_handler(struct input_handler *);
>  void input_unregister_handler(struct input_handler *);
>
> +int __must_check input_get_new_minor(int legacy_base, unsigned int legacy_num,
> +                                    bool allow_dynamic);
> +void input_free_minor(unsigned int minor);
> +
>  int input_handler_for_each_handle(struct input_handler *, void *data,
>                                   int (*fn)(struct input_handle *, void *));
>

Looks all good and works perfectly well for me.
Reviewed-by: David Herrmann <dh.herrmann@googlemail.com>

Dmitry, if you push it into linux-next soon, we might even get it into
3.7. And while looking over it, I noticed that it really isn't that
much of a functional change. We basically just move the cdev
allocation from the core into each handler so we didn't introduce any
new races/deadlocks. At least I didn't find one.

Thanks again!
David
