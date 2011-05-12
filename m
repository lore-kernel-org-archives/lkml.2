Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab1ELT5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 15:57:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758524Ab1ELT5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 15:57:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Raffaele Recalcati <lamiaposta71@gmail.com>
Subject: Re: [PATCH 2/4] PM / Loss: power loss management
Date: Thu, 12 May 2011 21:57:46 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, Davide Ciminaghi <ciminaghi@gnudd.com>,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <1305220265-9020-3-git-send-email-lamiaposta71@gmail.com>
In-Reply-To: <1305220265-9020-3-git-send-email-lamiaposta71@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105122157.46895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> From: Davide Ciminaghi <ciminaghi@gnudd.com>
> 
> On some embedded systems, an asynchronous power failure notification event is
> available some tens to hundreds milliseconds before the actual power failure
> takes place.
> Such an event can be used to trigger some actions, typically shutting down
> all non-vital power sinks, thus allowing the board to survive longer to
> temporary power losses.
> 
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
> Signed-off-by: Raffaele Recalcati <raffaele.recalcati@bticino.it>
> ---
>  Documentation/power/loss.txt |  191 +++++++++++++
>  drivers/base/bus.c           |    6 +
>  drivers/base/init.c          |    1 +
>  drivers/base/platform.c      |   14 +
>  drivers/base/power/Makefile  |    2 +
>  drivers/base/power/loss.c    |  648 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/base/power/power.h   |   14 +
>  include/linux/pm.h           |   16 +
>  include/linux/pm_loss.h      |  109 +++++++
>  kernel/power/Kconfig         |   27 ++
>  10 files changed, 1028 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/power/loss.txt
>  create mode 100644 drivers/base/power/loss.c
>  create mode 100644 include/linux/pm_loss.h
> 
> diff --git a/Documentation/power/loss.txt b/Documentation/power/loss.txt
> new file mode 100644
> index 0000000..10da89c
> --- /dev/null
> +++ b/Documentation/power/loss.txt
> @@ -0,0 +1,191 @@
> +**** POWER LOSS MANAGEMENT ****
> +
> +Davide Ciminaghi <ciminaghi@gnudd.com> 2011
> +
> +1. Overview
> +
> +On some embedded systems, an asynchronous power failure notification event is
> +available some tens to hundreds milliseconds before the actual power failure
> +takes place.
> +Such an event can be used to trigger some actions, typically shutting down
> +all non-vital power sinks, thus allowing the board to survive longer to
> +temporary power losses. Sometimes, also flash-based block devices can be
> +stopped after a power loss event notification has been received. This should
> +be useful for mmc devices, for which a sudden power failure while a write
> +command is being executed can threaten file system integrity even in case a
> +journalling fs is in use.
> +Generally speaking, one can expect the course of action taken when a power
> +failure warning is received to be deeply system specific. Similarly, the
> +mechanism used for power failure notifications can equally be board/platform
> +specific. For these reasons, support for power loss management has been split
> +into three parts:
> +
> +	+ Generic code (board and driver independent).
> +	+ Board dependent code.
> +	+ Power loss policy definition.
> +
> +The generic part of the code is located under drivers/base/power/loss.c .
> +On the other hand, board dependent code and power loss policies definitions
> +should live somewhere in the platform/board specific files.

I'm not really sure about that.  Do you want to hardcode policies in some
platform/board-specific files inside of the kernel?

> +The header file include/linux/pm_loss.h contains all the pm_loss function
> +prototypes, together with definitions of data structures.
> +For what concerns power loss policies, the framework already contains a couple
> +of predefined policies: "nop" and "default" (see later paragraphs for more
> +details).

I think it would be cleaner to split the patch so that the actual functionality
is added first and the policy part goes in a separate patch on top of that.

> +
> +1.1 Sysfs interface.
> +
> +It can be useful (for instance during tests), to be able to quickly switch
> +from one power loss policy to another, or to simulate power fail and resume
> +events. To this end, a sysfs interface of the following form has been devised:
> +
> +/sys/power/loss +
> +		|
> +		+-- active_policy
> +		|
> +		+-- policies -+
> +		|	      |
> +		|	      +-- nop
> +		|	      |
> +		|	      +-- default +
> +		|	      |		  |
> +		|	      |	 	  +-- bus_table
> +		|	      |
> +		|	      +-- ....
> +		|
> +		+-- pwrfail_sim
> +
> +2. Details
> +
> +2.1 Sending events to the power loss management core.
> +
> +The board specific code shall trigger a power failure event notification by
> +calling pm_loss_power_changed(SYS_PWR_FAILING).
> +In case of a temporary power loss, the same function shall be called with
> +SYS_PWR_GOOD argument on power resume. pm_loss_power_changed() can sleep, so
> +it shall not be called from interrupt context.
> +
> +2.3 Effects on bus and device drivers.
> +
> +One more entry has been added to the device PM callbacks:
> +
> +   int (*power_changed)(struct device *, enum sys_power_state);

Please don't use the second argument.  Make it two (or as many as you need)
callbacks each with one struct device * argument instead (following the
convention we have in struct dev_pm_ops already).

That said, I'm not quite sure we _need_ those additional callbacks at all.
Your example mmc implementation appears to use a simple "runtime suspend on
power fail, runtime resume on power good" approach, for which it's not
necessary to add any new callbacks.

> +This function can be optionally invoked by power loss policies in case of
> +system power changes (loss and/or resume). Of course every bus or device driver
> +can react to such events in some specific way. For instance the mmc block
> +driver will probably block its request queue during a temporary power loss.

I think you'd have to deal with user space somehow before suspending devices.
Runtime PM suspends devices when they aren't in use (as indicated by the
usage counters), but in this power loss case we may really end up suspending
devices that _are_ in use, right?

> +2.3.1 The platform bus.
> +
> +For what concerns platform bus drivers, platform specific code can override
> +the power_changed() callback :
> +
> +platform_pm_loss_power_changed(struct device *dev, enum sys_power_state s)
> +
> +whose default (empty) version is defined as a __weak symbol in
> +drivers/base/platform.c.

Please don't use any more __weak symbols in that file.

> +2.4 Power loss policies.
> +
> +A power loss policy can be registered via the pm_loss_register_policy()
> +function, which receives:
> +
> +      + A pointer to a struct pm_loss_policy_ops , which hosts the pointers
> +      to the policy's specific callbacks (see below for more details).
> +      + A pointer to a struct kobj_type, which will allow the pm loss core
> +      to setup the policy related directory under /sys/power/loss/policies.
> +      See Documentation/kobject.txt for more details on struct kobj_type.
> +      + A pointer to an array of chars containing the name of the policy.
> +      + A pointer to the policy's private data (void *).

This sounds like quilte a bit of new infrastructure and it seems it might
be implemented in a more straightforward way (presumably in a less general
but still useful manner).

> +A power loss policy can define the following callbacks:
> +
> +      + int (*bus_added)(struct pm_loss_policy *, struct bus_type *) : this
> +      is invoked whenever a new bus has been registered within the system.
> +      Since power related events are often managed at bus level, it can be
> +      useful for the policy to have a list of available busses within the
> +      system. When a policy is registered, this callback is invoked once
> +      for every already registered bus.

Well, we have a list of registered bus types anyway.  They may or may not
register "power loss" callbacks.  Why don't you simply execute the callbacks
from the bus types that defined them?  What exactly is the purpose of the
new list?

> +      + int (*bus_removed)(struct pm_loss_policy *, struct bus_type *):
> +      this is invoked when a bus is removed from the system.
> +      + int (*start)(struct pm_loss_policy *): this is called when a policy
> +      becomes active.
> +      + void (*stop)(struct pm_loss_policy *): this is called when a policy
> +      becomes inactive.

What are the start/stop callbacks needed for?  IOW, what's your envisioned
use case for those callbacks?

> +2.4.1 The nop predefined policy
> +
> +The nop policy is the first active policy when the pm loss framework is
> +initialized. It just does nothing in case of power loss / power resume
> +events.
> +
> +2.4.2 The default predefined policy
> +
> +When a power failure warning is received, the default policy walks through a
> +list of critical busses and invokes their drivers' power_changed() callback.

Why not to walk all bus types here?

> +The default policy can be customized and registered by calling:
> +
> +    pm_loss_setup_default_policy(struct pm_loss_default_policy_table *);
> +
> +This function receives a pointer to a pm_loss_default_policy_table structure,
> +which defines a priority ordered list of critical buffers:
> +
> +      struct pm_loss_default_policy_table {
> +	     struct module *owner ;
> +	     const char *name ;
> +	     struct pm_loss_default_policy_item *items;
> +	     int nitems;
> +      };
> +
> +Here's a short description of such structure:
> +
> +      + owner  : shall point to the module registering the table (or NULL
> +		 if the table is not instantiated by a module).
> +      + name   : this is the name given to this particular customization of
> +		 the default policy.
> +      + items  : pointer to an array of table items.
> +      + nitems : number of the items in the array.
> +
> +Each item is a struct pm_loss_default_policy_item, defined as follows:
> +
> +     struct pm_loss_default_policy_item {
> +	const char *bus_name;
> +	int bus_priority ;
> +     };
> +
> +where bus_name is the name of a bus and bus_priority is a numerical priority
> +of the bus itself. Numerically higher priorities correspond to more prioritary
> +busses.

So I can understand the need for priorities, but why do you use the name
instead of a pointer to struct bus_type?

> +
> +2.4.3 Activating a specific policy.
> +
> +A policy can be activated:
> +
> +	+ From within the kernel by calling pm_loss_set_policy(char *name).
> +	The argument passed to this function shall be the name of the policy
> +	to be activated.
> +
> +	+ From user space by writing the name of the policy to be activated
> +	to /sys/power/loss/active_policy.
> +
> +2.4.4 Unregistering a policy
> +
> +For a generic user defined policy, just call :
> +
> +     pm_loss_unregister_policy(struct pm_loss_policy *);
> +
> +For a default policy customization:
> +
> +     pm_loss_shutdown_default_policy(struct pm_loss_policy *);
> +
> +3. Kernel configuration
> +
> +The following configuration options have been defined:
> +
> +    CONFIG_PM_LOSS     : this enables the generic pm_loss framework.
> +    CONFIG_PM_LOSS_SIM : this adds the pwrfail_sim file to the sysfs interface
> +		         and allows power loss events simulation.
> +    CONFIG_PM_LOSS_DEBUG : this option enables some debug printk's .
> +    CONFIG_PM_LOSS_TEST: this enables the compilation of a sample test module
> +                         containing a customized default policy definition

OK, so I think that this feature may be kind of useful, but it will require
some work before it's ready to go into the kernel.

Please separate the policy part for starters and let's see what's left.

Thanks,
Rafael
