Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab1LFENf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 23:13:35 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:53636 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932880Ab1LFENd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 23:13:33 -0500
Message-ID: <4EDDA44A.4000208@xenotime.net>
Date: Mon, 05 Dec 2011 21:12:42 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alessandro Rubini <rubini@gnudd.com>
CC: linux-iio@vger.kernel.org, greg@kroah.com, linux-kernel@vger.kernel.org,
        federico.vaga@gmail.com, dcobas@cern.ch, siglesia@cern.ch,
        manohar.vanga@cern.ch
Subject: Re: [RFC PATCH 1/7] Documentation: add docs for drivers/zio
References: <cover.1322328073.git.rubini@gnudd.com> <136508309048abae5ff23c5230e9344c51442849.1322328075.git.rubini@gnudd.com>
In-Reply-To: <136508309048abae5ff23c5230e9344c51442849.1322328075.git.rubini@gnudd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2011 09:30 AM, Alessandro Rubini wrote:
> This is documentation for the beta3 release of zio.
> The files match commit 7d37663 in git://ohwr.org/misc/zio.git .
> 
> We are aware the "modules.txt" file is not correct as it lists files
> that are not ready. We decided to avoid fixing it for this RFC
> submission, which won't go upstream anyways.
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
> Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
> Acked-by: Samuel Iglesias Gonsalvez <siglesia@cern.ch>
> Acked-by: Manohar Vanga <manohar.vanga@cern.ch>
> ---
>  Documentation/zio/00-INDEX    |   10 +++
>  Documentation/zio/buffer.txt  |  114 ++++++++++++++++++++++++++++++++++++
>  Documentation/zio/device.txt  |   69 ++++++++++++++++++++++
>  Documentation/zio/modules.txt |   45 ++++++++++++++
>  Documentation/zio/trigger.txt |  128 +++++++++++++++++++++++++++++++++++++++++
>  drivers/zio/README            |  105 +++++++++++++++++++++++++++++++++
>  6 files changed, 471 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/zio/00-INDEX
>  create mode 100644 Documentation/zio/buffer.txt
>  create mode 100644 Documentation/zio/device.txt
>  create mode 100644 Documentation/zio/modules.txt
>  create mode 100644 Documentation/zio/trigger.txt
>  create mode 100644 drivers/zio/README
> 
> diff --git a/Documentation/zio/00-INDEX b/Documentation/zio/00-INDEX
> new file mode 100644
> index 0000000..093d9fb
> --- /dev/null
> +++ b/Documentation/zio/00-INDEX
> @@ -0,0 +1,10 @@
> +00-INDEX
> +	- this file
> +device.txt
> +	- description of what ZIO devices (and csets and channels) are.
> +buffer.txt
> +	- description of the buffer, it's methods and how it is used.

	                             its

> +trigger.txt
> +	- what is a trigger and what's its role in ZIO.
> +modules.txt
> +	- list of modules (and description) found in the first ZIO package

> diff --git a/Documentation/zio/buffer.txt b/Documentation/zio/buffer.txt
> new file mode 100644
> index 0000000..f80e63a
> --- /dev/null
> +++ b/Documentation/zio/buffer.txt
> @@ -0,0 +1,114 @@
> +
> +ZIO defines a "buffer" object type, so each device can exploit any
> +features it may offer to speed up data transfers.
> +
> +Each cset in a device can use a different buffer, which is specified
> +as an attribute of the cset.  One instance of the buffer type exists
> +for each channel, and the char devices (control and data: see
> +device.txt) refer to the buffer.
> +
> +Please read <linux/zio-buffer.h> together with this file.
> +
> +	Buffer Types
> +	============
> +
> +Buffers may be device-specific or generic. A generic buffer called
> +"kmalloc" is provided within zio-core; it uses kmalloc for allocation
> +data blocks.  Such buffer is activated by default on all new csets
> +being registered but is not special in any other way, you can write

                                                    way.  You can write

> +your own generic buffer (and if it's better than ours, we may use it
> +as default buffer in future releases).
> +
> +A device-specific buffer declares to be such within its attributes.  A
> +device-specific buffer can only be used by csets that declare its name
> +as preferred buffer type.  When such csets are registered, if the
> +buffer is already known to ZIO, it will be activated by default instead
> +of "kmalloc".
> +
> +Sometimes people write drivers for a set of similar devices, with
> +similar DMA capabilities. In this case, all of them may refer to the
> +same device-specific buffer type; the buffer type may be registered
> +as a standalone kernel module.
> +
> +The ZIO buffer data structures includes two sets of operations:
> +file_operations and buffer_operations.
> +
> +
> +	Buffer Operations
> +	=================
> +
> +Each buffer type must provide the following buffer operations. All
> +of them are implemented in zio-buf-kmalloc.c, which may be used as
> +reference to better understand the role of each method:
> +
> +	struct zio_bi *(*create)(struct zio_buffer_type *zbuf,
> +				 struct zio_channel *ch,
> +				 fmode_t f_flags);
> +	void (*destroy)(struct zio_bi *bi);
> +
> +The create() operation allocates and initializes an instance of the
> +buffer type. It is called by ZIO when a channel is opened for the
> +first time. The operation return a zio buffer instance (zio_bi),

                             returns a

> +which is the generic descriptor of a buffer instance. ZIO handles
> +only zio_bi, so complex buffer structures must contain the zio_bi
> +structure and use container_of() to access the private enclosing
> +structure.
> +
> +Destroy() deallocates a buffer instance. ZIO calls destroy when the

   destroy()                                          destroy()


> +channel is unregistered from ZIO or when the user assigns a different
> +buffer type to the channel.
> +
> +When the control/data devices are closed, ZIO doesn't call destroy, so

                                                              destroy(), so

> +incoming data can queue up while the application leaves it closed
> +(e.g., a shell script).  Actually, the release file operation is not
> +handled by ZIO, so it couldn't call destroy on close even if it wanted
> +to.
> +
> +	struct zio_block *(*alloc_block)(struct zio_bi *bi,
> +					 struct zio_control *ctrl,
> +					 size_t datalen, gfp_t gfp);
> +	void (*free_block)(struct zio_bi *bi, struct zio_block *block);
> +
> +For input channels, a block is allocated before the trigger fires, and
> +it is freed when the user has read or explicitly ignored it. For
> +output, allocation happens on user write and free is called by the
> +trigger when it is done. Thus, the functions are sometimes called by
> +buffer code itself, and sometimes by the trigger. The generic
> +structure hosting a block is zio_block which contain both data
> +(samples) and control informations.  If needed, buffers may use a more

                         information.

> +complex structure, which will include zio_block, which is the only
> +structure that ZIO handles; by using container_of you can retrieve the
> +enclosing complex structure used in your buffer

                                            buffer.

> +
> +	int (*store_block)(struct zio_bi *bi, struct zio_block *block);
> +	struct zio_block (*retr_block) (struct zio_bi *bi);
> +
> +For input the trigger calls store_block() and the read system call issues
> +retr_block().  For output, the write system call runs store_block()
> +and the trigger may call retr_block() (although the buffer pushes to
> +the trigger when it receives the first data block).
> +
> +
> +	File Operations
> +	===============
> +
> +This field hosts the file_operations used by the char devices (control and

   This structure holds

> +data) for every channel using this buffer type.  When char devices are
> +initially opened, the open method being run is within zio-code;
> +it  kmallocs f->private_data before calling the buffer-specific open
> +method. The private data being used is:
> +
> +	struct zio_f_priv {
> +		struct zio_channel *chan;
> +		enum zio_cdev_type type;
> +	};
> +
> +All buffer file operations can thus refer to the current channel (and
> +its buffer and its trigger), and know if the current file is
> +ZIO_CDEV_CTRL or ZIO_CDEV_DATA.  Every buffer is expected to
> +call zio_generic_release() at the end of its own release operation, or
> +used zio_generic_release() directly in the file operations.
> +
> +ZIO offers other generic file operations, that may be enough for your

drop comma above.

> +buffer code or not. See zio-buf-kmalloc.c for a working example of

               or may not.

> +buffer file operations.

> diff --git a/Documentation/zio/device.txt b/Documentation/zio/device.txt
> new file mode 100644
> index 0000000..0c960e2
> --- /dev/null
> +++ b/Documentation/zio/device.txt
> @@ -0,0 +1,69 @@
> +
> +	ZIO Device
> +	==========
> +
> +A device, registered through zio_register_device() is the description

drop comma above.

> +of an I/O peripheral. It is made up of channel-sets, called csets
> +from now on. A device may represent a PCI board or an SPI integrated
> +circuit or whatever it makes sense to manage from a single device driver.
> +All I/O operations are performed on csets, so the device is just an
> +array of csets.
> +
> +	Csets
> +	=====
> +
> +A cset (channel-set) is an homogeneous set of I/O channels. All
> +channels in the set are feature the same physical characteristics;

drop                   are ??

> +moreover, a cset refers to a trigger object, so all channels in a set
> +are triggered by the same event. This is the typical use case for
> +logic analysers (digital input) or multi-probe scopes (analog input),
> +as well as multi-waveform output. If your device has several input
> +channels which are separately triggered, they should be defined as
> +several cset items, each featuring one channel only.  Finally, all
> +channels in a cset use the same buffer object for in-kernel data
> +storage. Both the buffer and the trigger for a cset are set by
> +writing the proper name in sysfs. At device registration defaults
> +apply. If ZIO can't find the trigger/buffer name you wrote,
> +it will return EINVAL and leave the previous trigger/buffer in place.
> +
> +	Channels
> +	========
> +
> +The channel is the lowest object in the ZIO hierarchy. It represents
> +the single physical connector of the device: analog or digital, input
> +or output. Time-to-digital and digital-to-time devices can be represented
> +as channels as well.
> +
> +	Attributes
> +	==========
> +
> +Most configuration and information in ZIO happens through sysfs.
> +See sysfs.txt for information about attributes. (FIXME: sysfs.txt)
> +
> +	Data Transfers
> +	==============
> +
> +Data transfer in ZIO uses two char devices for each channel offered by
> +the driver. One char device is used to describe data blocks (we call
> +it control device); the other is used to transfer the data blocks (we
> +call it data device). The control device returns (or accepts) a
> +fixed-size structure that describes the next data transfer, including
> +the trigger in use, data size, number of samples and various
> +attributes.  Applications may choose to read the data device alone,
> +without retrieving control information: when any data of a new block
> +is transferred, the associated control information is discarded.
> +Similarly, data is discarded if you re-read the control device after
> +having retrieved the description of a data block you are not
> +interested in.  For output, writing data without writing control uses
> +the default control information, or the one from the previous
> +transfer.
> +
> +The full set of rules for data and control transfers is described
> +elsewhere (FIXME: link to other docs) but it is pretty intuitive once
> +you get the idea.
> +
> +See the "zio-dump" host tool in the top-level zio dir for an example

                                                     directory

> +of generic and simple input application that shows use of control and

   of a generic and simple

> +data files.
> +
> +

Drop ending blank lines.

> diff --git a/Documentation/zio/modules.txt b/Documentation/zio/modules.txt
> new file mode 100644
> index 0000000..b3df00a
> --- /dev/null
> +++ b/Documentation/zio/modules.txt
> @@ -0,0 +1,45 @@
> +
> +This is the list of ZIO modules, at the time of writing. It is there

                                                                  here

> +to help new users understanding how the parts stick together.
> +
> +  drivers/zio/zio-core.ko
> +
> +This module (which is linked from several source files) includes the
> +core sysfs and attribute management. It exports the register and
> +unregister functions for top-level objects. Moreover, it includes the
> +default buffer, called "kmalloc" and default trigger, called
> +"app-request".
> +
> +  drivers/zio/trigger/trig-ktimer.ko
> +  drivers/zio/trigger/trig-hrt.ko
> +  drivers/zio/trigger/trig-irq.ko
> +
> +Three other generic triggers. Two of them are time-based, and the
> +third hooks to an external interrupt (or more than one) as source of
> +trigger that can be used be any zio cset).
> +
> +  drivers/zio/dev/zio-null.ko
> +  drivers/zio/dev/zio-parport.ko
> +  drivers/zio/dev/zio-ad7888.ko
> +  drivers/zio/dev/zio-uart.ko
> +
> +These modules are examples. "null" does nothing: it discards output
> +data and returns zeroes as input data. It can be used to experiment
> +with generic triggers and as a sandbox for local modifications and
> +testing.
> +
> +The parport driver registers two output csets and two input cset.

                                                               csets.

> +In each group one cset is byte-oriented and the other is bit-oriented.
> +
> +The ad7888 is an SPI ADC we mounted on an ARM board. It's a real
> +8-channel ADC we are using for internal development, and this is a
> +real driver for a real thing. Over time it will handle its own buffer
> +type (our SPI master uses DMA) and its own data-driven trigger (even
> +if the data will be scanned by the CPU, so it can only work at low
> +data rates).
> +
> +The uart driver is a line discpline that can receive data from a

       UART                  discipline

> +serial port. The first implementation expects to receive an endless
> +stream of 16-bit data, big endian (we used this to run on-board ADC on
> +cortex-m3), but we plan to extend it as a serious test case. You can
> +drive it from a pty slave, for example.

> diff --git a/Documentation/zio/trigger.txt b/Documentation/zio/trigger.txt
> new file mode 100644
> index 0000000..95b426f
> --- /dev/null
> +++ b/Documentation/zio/trigger.txt
> @@ -0,0 +1,128 @@
> +
> +ZIO defines a "trigger" object type, and each cset is connected to
> +a trigger.
> +
> +Each cset in a device can use a different trigger, which is specified
> +as an attribute of the cset.  When the trigger fires, it acts on all
> +the non-disabled channels of the cset.  Only the "app-request" trigger
> +can act on a single channel at a time.
> +
> +Please read <linux/zio-trigger.h> together with this file.
> +
> +	Trigger Types
> +	=============
> +
> +Triggers may be device-specific or generic. A few generic triggers
> +are part of zio-core. The "app-request" trigger fires input when
> +the application calls read and fires output when the application calls
> +write (it acts on a single channel). The "ktimer" trigger uses a kernel
> +timer as trigger source. The "irq" trigger uses any interrupt (e.g.,
> +a GPIO interrupt, or pin 10 of the PC parallel port) as trigger event.
> +
> +A device-specific trigger declares to be such within its attributes.  A
> +device-specific trigger can only be used by csets that declare its name
> +as preferred trigger type.  When such csets are registered, if the
> +trigger is already known to ZIO, it will be activated by default instead
> +of "app-request".
> +
> +	Trigger Operations
> +	==================
> +
> +Trigger operations are the following:
> +
> +	struct zio_ti *(*create)(struct zio_trigger_type *trig,
> +				 struct zio_cset *cset,
> +				 struct zio_control *ctrl,
> +				 fmode_t flags);
> +	void (*destroy)(struct zio_ti *ti);
> +
> +Create and destroy a trigger instance for a cset. ZIO calls create() when
> +attaching the trigger to a cset; it calls destroy() when the trigger is
> +replaced by a different one or the cset is being unregistered from ZIO.
> +The instance structure is trigger-specific, but it must include the
> +generic structure zio_ti. Every time this structure is passed over, trigger
> +code may use container_of if it needs to access the private enclosing
> +structure.
> +
> +	int (*config)(struct zio_ti *ti, stuct zio_control *ctrl);
> +
> +The method is called by ZIO whenever the attributes for a trigger
> +instance are modified by the user (by writing to sysfs or otherwise).
> +
> +	int (*push_block)(struct zio_ti *ti,
> +			  struct zio_channel *chan,
> +			  struct zio_control *ctrl);
> +
> +This is used for output channels: when a new data block is ready, it
> +must be sent to the trigger so it can be output when the event fires.
> +Buffer code, therefore, is expected to call this trigger method.  The
> +function can return -EAGAIN if it has no space in the queue, or 0 on
> +success. If EAGAIN happens, the buffer should handle it (by storing
> +locally or notifying the user).
> +
> +	void (*pull_block)(struct zio_ti *ti,
> +	  		   struct zio_channel *chan);
> +
> +The method asks the trigger for a new block. It may be called by
> +the buffer, if it wants a block immediately. The trigger that offers
> +this method (which may be NULL) is responsible of storing a block

                                                  for storing

> +when available.  Since driver->input_cset completes asynchronously, this
> +method can't return a block directly.  The block that will be stored
> +may be shorter than what the trigger would have stored in the buffer
> +by itself.
> +
> +        void (*data_done)(struct zio_cset *cset);
> +
> +The function is called by the device, and signals the trigger that
> +the input or output operation on the cset is over. For input, the
> +trigger will push blocks to the buffer, for output it will release

                                   buffer; for

> +the blocks.  zio-core offers zio_generic_data_done() for triggers
> +that don't need special handling.
> +
> +	File Operations
> +	===============
> +
> +The trigger may include a non-NULL f_ops pointer. Most triggers will
> +not need it, but for example "app-request" does, because it needs to
> +look at individual read and write calls performed by applications.
> +ZIO will use these file operations (instead of the buffer file operations)
> +when the open method of the char device detects that the active trigger
> +declares a non-NULL f_ops field.  These operations will most
> +likely fall back to buffer->f_ops for most of their actual work.
> +
> +See zio-trig-app-request.c for details about how this is used.
> +
> +	When the trigger fires
> +	======================
> +
> +The trigger event may happen for a variety of reasons. It can be
> +time-driven, data-driven or whatever else.  In any case, there is
> +a time when the trigger fires, so input or output may happen.
> +(With most hardware-specific triggers, the actual input or output of
> +data has already happened when the trigger interrupt runs, but this
> +doesn't change the software flow).
> +
> +Hardware-driven triggers will need to make their own work by themselves,
> +but ZIO offers this help macro to loop over all non-disabled channels:

                       helper macro

> +
> +	cset_for_each(struct zio_cset *cset, struct zio_channel *ch)
> +
> +The macro works like "task_for_each" or "list_for_each" in the kernel
> +headers.
> +
> +For software-based triggers (where actual I/O happens when software
> +wants it to happen, even if it is in response to an interrupt), the
> +asynchronous code that runs the event will just need to call
> +
> +	zio_fire_trigger(struct zio_ti *ti);
> +
> +This function, part of zio-core, calls the internal helpers
> +__zio_fire_input_trigger for input or __zio_fire_output_trigger for
> +output. For input, block allocation is performed for each
> +non-disabled channel, and drv->input_cset is called.
> +For output, drv->outoput_cset is called.
> +
> +You can refer to "zio-trig-timer" for an example of a multi-instance
> +generic timer and to "zio-trig-app-request" for a non-conventional
> +implementation based on trigger-local file_operations.
> +

Drop last blank line.

> diff --git a/drivers/zio/README b/drivers/zio/README
> new file mode 100644
> index 0000000..d537353
> --- /dev/null
> +++ b/drivers/zio/README

I'd prefer to see this file in Documentation/zio/ with the other doc files.

> @@ -0,0 +1,105 @@
> +
> +Zio is "the ultimate I/O framework".  Is being developed on the open

                                         It is being

> +hardware repository at http://www.ohwr.org/projects/zio .
> +
> +This version is known to compile and run with kernels 2.6.34 onwards.
> +
> +This README refers to version "beta3", but work is ongoing towards
> +a stable package. See the TODO file on ohwr for details.
> +
> +To test zio you need to load the core modules (later, the default
> +trigger and default buffer will be part of zio-core):
> +
> +   	insmod zio-core.ko
> +   	insmod buffers/zio-buf-kmalloc.ko
> +   	insmod triggers/zio-trig-timer.ko
> +
> +Drivers can't live without a trigger and a buffer, so the modules above
> +must be loaded first.
> +
> +The kmalloc buffer is a simple buffer that hosts a list of data blocks,
> +for either input or output.
> +
> +The timer trigger is a kernel-timer based trigger, that fires a block
> +transfer on a timely basis. You can use the "ms" parameter to set the
> +inter-block time, in milliseconds (the default is two seconds). You
> +can also pass the "nsamples" parameter to say how many samples are
> +aquired at each trigger instance.

   acquired

> +
> +With the core in place, you can load a driver:
> +
> +	insmod drivers/zio-zero.ko
> +
> +zio-zero has a single channel-set (number 0) with three channels.
> +They simulate three analog inputs, 8-bit per sample.

                                      8 bits per sample.

> +
> +     channel 0: returns zero forever
> +     channel 1: returns random numbers
> +     channel 2: returns a sawtooth signal (0 to 255 and back)
> +
> +The char devices are called using device-cset-channel:
> +
> +    /dev/zzero-0-0-ctrl
> +    /dev/zzero-0-0-data
> +    /dev/zzero-0-1-ctrl
> +    /dev/zzero-0-1-data
> +    /dev/zzero-0-2-ctrl
> +    /dev/zzero-0-2-data
> +
> +(later versions will use a /dev/zio/ directory for all zio files)
> +
> +To read data you can just cat, or "od -t x1" the data device.
> +To get control information meta-information) together with data, you
> +can use the "zio-dump" user-space utility, in this directory.
> +
> +For example:
> +
> +    ./zio-dump /dev/zzero-0-2-ctrl /dev/zzero-0-2-data
> +
> +This is the result with a trigger that uses 2000 as msec and 32
> +as nsample:
> +
> +    ./zio-dump /dev/zzero-0-2-ctrl /dev/zzero-0-2-data
> +
> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 2
> +    Ctrl: seq 1, n 32, size 1, bits 8, flags 01000001 (little-endian)
> +    Ctrl: stamp 1320403540.084798370 (0)
> +    Data: 00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f
> +    Data: 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f
> +
> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 2
> +    Ctrl: seq 2, n 32, size 1, bits 8, flags 01000001 (little-endian)
> +    Ctrl: stamp 1320403542.091093781 (0)
> +    Data: 20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f
> +    Data: 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f
> +
> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 2
> +    Ctrl: seq 3, n 32, size 1, bits 8, flags 01000001 (little-endian)
> +    Ctrl: stamp 1320403544.084790274 (0)
> +    Data: 40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f
> +    Data: 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f
> +
> +Zio dump is able to access several pairs of devices (control and data),

   zio-dump

> +and you can change the trigger and buffer attributes for the cset.
> +
> +Example:
> +
> +    echo 500 > /sys/zio/devices/zzero/cset0/trigger/ms-period
> +    echo 4 > /sys/zio/devices/zzero/cset0/trigger/nsamples
> +    echo 3 > /sys/zio/devices/zzero/cset0/chan0/buffer/max-buffer-len
> +    ./zio-dump /dev/zzero-0-*
> +
> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 0
> +    Ctrl: seq 102, n 4, size 1, bits 8, flags 01000001 (little-endian)
> +    Ctrl: stamp 4066.519285605 (0)
> +    Data: 00 00 00 00
> +
> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 1
> +    Ctrl: seq 102, n 4, size 1, bits 8, flags 01000001 (little-endian)
> +    Ctrl: stamp 4066.519285605 (0)
> +    Data: 71 29 a6 53
> +
> +    Ctrl: version 0.2, trigger timer, dev zzero, cset 0, chan 2
> +    Ctrl: seq 102, n 4, size 1, bits 8, flags 01000001 (little-endian)
> +    Ctrl: stamp 4066.519285605 (0)
> +    Data: 60 61 62 63


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
