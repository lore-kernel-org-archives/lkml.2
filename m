Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab1EMNOT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 09:14:19 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:64296 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758584Ab1EMNOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 09:14:18 -0400
X-Greylist: delayed 673 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 May 2011 09:14:16 EDT
Date: Fri, 13 May 2011 15:02:12 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Raffaele Recalcati <lamiaposta71@gmail.com>,
        linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org,
        Raffaele Recalcati <raffaele.recalcati@bticino.it>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 2/4] PM / Loss: power loss management
Message-ID: <20110513130212.GF29259@mail.gnudd.com>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com> <1305220265-9020-3-git-send-email-lamiaposta71@gmail.com> <201105122157.46895.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <201105122157.46895.rjw@sisk.pl>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:57:46PM +0200, Rafael J. Wysocki wrote:
> Hi,
>
> On Thursday, May 12, 2011, Raffaele Recalcati wrote:
> > From: Davide Ciminaghi <ciminaghi@gnudd.com>
> > 

hello, I (Davide) will reply as the patch author.

....................
> 
> I'm not really sure about that.  Do you want to hardcode policies in some
> platform/board-specific files inside of the kernel?
> 

I think a little history of the patch can help: it looks like recent mmc 
devices can do any sort of weird things in case of sudden power losses during 
write operations. This is still to be confirmed by actual tests on our
particular hardware, but we suspect that even a journalling fs could be 
corrupted in such a case. 
Stopping the mmc request queue when a power loss is detected, does not 
completely solve the problem, but at least mitigates the risk of disasters.
Plus, we needed to get our board to immediately turn off any unneeded power 
sink in case of temporary power losses (just try to survive as long as you 
can ...). 
Our hardware triggers an interrupt about 100 millisenconds before the cpu 
dies, so we needed to notify the drivers about the event as fast as we could.
That was one of the two main reasons why we chose to put this stuff inside 
the kernel. The other reason was that the mmc request queue can be easily 
stopped from kernel space.
Since forcing a given policy seemed the wrong thing to do, we chose to adopt
a modular policy approach.

> > +The header file include/linux/pm_loss.h contains all the pm_loss function
> > +prototypes, together with definitions of data structures.
> > +For what concerns power loss policies, the framework already contains a couple
> > +of predefined policies: "nop" and "default" (see later paragraphs for more
> > +details).
> 
> I think it would be cleaner to split the patch so that the actual functionality
> is added first and the policy part goes in a separate patch on top of that.
> 

agreed.

> > +
> > +1.1 Sysfs interface.
> > +
> > +It can be useful (for instance during tests), to be able to quickly switch
> > +from one power loss policy to another, or to simulate power fail and resume
> > +events. To this end, a sysfs interface of the following form has been devised:
> > +
> > +/sys/power/loss +
> > +		|
> > +		+-- active_policy
> > +		|
> > +		+-- policies -+
> > +		|	      |
> > +		|	      +-- nop
> > +		|	      |
> > +		|	      +-- default +
> > +		|	      |		  |
> > +		|	      |	 	  +-- bus_table
> > +		|	      |
> > +		|	      +-- ....
> > +		|
> > +		+-- pwrfail_sim
> > +
> > +2. Details
> > +
> > +2.1 Sending events to the power loss management core.
> > +
> > +The board specific code shall trigger a power failure event notification by
> > +calling pm_loss_power_changed(SYS_PWR_FAILING).
> > +In case of a temporary power loss, the same function shall be called with
> > +SYS_PWR_GOOD argument on power resume. pm_loss_power_changed() can sleep, so
> > +it shall not be called from interrupt context.
> > +
> > +2.3 Effects on bus and device drivers.
> > +
> > +One more entry has been added to the device PM callbacks:
> > +
> > +   int (*power_changed)(struct device *, enum sys_power_state);
> 
> Please don't use the second argument.  Make it two (or as many as you need)
> callbacks each with one struct device * argument instead (following the
> convention we have in struct dev_pm_ops already).
> 
> That said, I'm not quite sure we _need_ those additional callbacks at all.
> Your example mmc implementation appears to use a simple "runtime suspend on
> power fail, runtime resume on power good" approach, for which it's not
> necessary to add any new callbacks.
> 

maybe this is design choice comes from our little knowledge of pm_runtime, 
but the reason why we didn't use the existing callbacks was that we wanted 
to avoid any possible conflict.
In our understanding, pm_runtime works more or less like this: "when 
you're done with a peripheral, turn it off" (well, maybe also wait a little 
while to avoid continuously toggling power on and off, thus wasting more 
power than just doing nothing). This is because its goal is to save power 
during normal operation.
On the other hand, we needed something like this: "when some external event 
takes place, just turn off anything you can as fast as you can".
Actually, one of the attempts we made before adding pm_loss was to implement 
it via pm_runtime, by just immediately stopping devices on idle and refusing
to turn them on again in case a power loss event took place in the meanwhile.
This worked, and was ok for drivers with no implementation of the pm_runtime 
callbacks, but introduced a potential conflict as far as pm_runtime enabled 
drivers were concerned. That's why we (maybe wrongfully) thought a new 
callback was needed.

> > +This function can be optionally invoked by power loss policies in case of
> > +system power changes (loss and/or resume). Of course every bus or device driver
> > +can react to such events in some specific way. For instance the mmc block
> > +driver will probably block its request queue during a temporary power loss.
> 
> I think you'd have to deal with user space somehow before suspending devices.
> Runtime PM suspends devices when they aren't in use (as indicated by the
> usage counters), but in this power loss case we may really end up suspending
> devices that _are_ in use, right?
> 
yes. This is not a problem for us right now, because when a power loss happens,
the "power bad" condition just lasts for about 100ms. At present, pm_loss
callbacks are implemented for the mmc block device and a video capture device
only.
In practice what happens on our platform is that processes accessing the mmc 
can be put to sleep until either the board dies or a power resume event takes 
place. If video capture is running, some "black" frames are generated, but 
that is not considered a real fault because power losses should not occur 
during normal operation (unless you really turn the board off, of course).

That said, I think you're right anyway, userspace should be notified somehow.
SIGPWR to init ?. As far as I know, there's no single place in the kernel 
where SIGPWR is sent to init:

find . -name \*.c  | xargs grep SIGPWR
...
./drivers/char/snsc_event.c:            kill_cad_pid(SIGPWR, 0);
...
./arch/s390/kernel/nmi.c:               kill_cad_pid(SIGPWR, 1);

Maybe pm_loss could become such a place ?

> > +2.3.1 The platform bus.
> > +
> > +For what concerns platform bus drivers, platform specific code can override
> > +the power_changed() callback :
> > +
> > +platform_pm_loss_power_changed(struct device *dev, enum sys_power_state s)
> > +
> > +whose default (empty) version is defined as a __weak symbol in
> > +drivers/base/platform.c.
> 
> Please don't use any more __weak symbols in that file.
>
ok.
 
> > +2.4 Power loss policies.
> > +
> > +A power loss policy can be registered via the pm_loss_register_policy()
> > +function, which receives:
> > +
> > +      + A pointer to a struct pm_loss_policy_ops , which hosts the pointers
> > +      to the policy's specific callbacks (see below for more details).
> > +      + A pointer to a struct kobj_type, which will allow the pm loss core
> > +      to setup the policy related directory under /sys/power/loss/policies.
> > +      See Documentation/kobject.txt for more details on struct kobj_type.
> > +      + A pointer to an array of chars containing the name of the policy.
> > +      + A pointer to the policy's private data (void *).
> 
> This sounds like quilte a bit of new infrastructure and it seems it might
> be implemented in a more straightforward way (presumably in a less general
> but still useful manner).
>
well, we just followed the most generic approach. Maybe it could be simplified.
 
> > +A power loss policy can define the following callbacks:
> > +
> > +      + int (*bus_added)(struct pm_loss_policy *, struct bus_type *) : this
> > +      is invoked whenever a new bus has been registered within the system.
> > +      Since power related events are often managed at bus level, it can be
> > +      useful for the policy to have a list of available busses within the
> > +      system. When a policy is registered, this callback is invoked once
> > +      for every already registered bus.
> 
> Well, we have a list of registered bus types anyway.  They may or may not
> register "power loss" callbacks.  Why don't you simply execute the callbacks
> from the bus types that defined them?  What exactly is the purpose of the
> new list?
> 
this list is ordered by priority.

> > +      + int (*bus_removed)(struct pm_loss_policy *, struct bus_type *):
> > +      this is invoked when a bus is removed from the system.
> > +      + int (*start)(struct pm_loss_policy *): this is called when a policy
> > +      becomes active.
> > +      + void (*stop)(struct pm_loss_policy *): this is called when a policy
> > +      becomes inactive.
> 
> What are the start/stop callbacks needed for?  IOW, what's your envisioned
> use case for those callbacks?
> 

Honestly they were added without having nothing special in mind (it just looked
more flexible), and in fact we were going to remove them, until they showed
useful if a policy table is owned by a module. In such case 
you need some place to do module_get/put, and start/stop looked just the 
right place. So, since we found at least one possible use for them, we decided
to leave them in place.
Actually, your question made me review the code and I've just found that
try_module_get() is called from pm_loss_setup_default_policy(), not from
the start() callback of the default policy. This looks strange, I think I
should review this part.

> > +2.4.1 The nop predefined policy
> > +
> > +The nop policy is the first active policy when the pm loss framework is
> > +initialized. It just does nothing in case of power loss / power resume
> > +events.
> > +
> > +2.4.2 The default predefined policy
> > +
> > +When a power failure warning is received, the default policy walks through a
> > +list of critical busses and invokes their drivers' power_changed() callback.
> 
> Why not to walk all bus types here?
> 
because of priorities. More prioritary busses are notified first.

> > +The default policy can be customized and registered by calling:
> > +
> > +    pm_loss_setup_default_policy(struct pm_loss_default_policy_table *);
> > +
> > +This function receives a pointer to a pm_loss_default_policy_table structure,
> > +which defines a priority ordered list of critical buffers:
> > +
> > +      struct pm_loss_default_policy_table {
> > +	     struct module *owner ;
> > +	     const char *name ;
> > +	     struct pm_loss_default_policy_item *items;
> > +	     int nitems;
> > +      };
> > +
> > +Here's a short description of such structure:
> > +
> > +      + owner  : shall point to the module registering the table (or NULL
> > +		 if the table is not instantiated by a module).
> > +      + name   : this is the name given to this particular customization of
> > +		 the default policy.
> > +      + items  : pointer to an array of table items.
> > +      + nitems : number of the items in the array.
> > +
> > +Each item is a struct pm_loss_default_policy_item, defined as follows:
> > +
> > +     struct pm_loss_default_policy_item {
> > +	const char *bus_name;
> > +	int bus_priority ;
> > +     };
> > +
> > +where bus_name is the name of a bus and bus_priority is a numerical priority
> > +of the bus itself. Numerically higher priorities correspond to more prioritary
> > +busses.
> 
> So I can understand the need for priorities, but why do you use the name
> instead of a pointer to struct bus_type?
>
The idea here was to make it simpler writing a bus priority table.
For instance this is how a sample table looks now:

struct pm_loss_default_policy_item my_board_pm_loss_policy_items[] = {
        {
                .bus_name = "mmc",
                .bus_priority = MY_BOARD_PWR_FAIL_PRIO_1,
        },
        {
                .bus_name = "platform",
                .bus_priority = MY_BOARD_PWR_FAIL_PRIO_2,
        },
};

A struct bus_type * would be less immediate.
Using a name is slower, but the operation of finding a bus given its name
is only done when you register the policy (or when a new bus is added after
policy registration).
 
> > +
> > +2.4.3 Activating a specific policy.
> > +
> > +A policy can be activated:
> > +
> > +	+ From within the kernel by calling pm_loss_set_policy(char *name).
> > +	The argument passed to this function shall be the name of the policy
> > +	to be activated.
> > +
> > +	+ From user space by writing the name of the policy to be activated
> > +	to /sys/power/loss/active_policy.
> > +
> > +2.4.4 Unregistering a policy
> > +
> > +For a generic user defined policy, just call :
> > +
> > +     pm_loss_unregister_policy(struct pm_loss_policy *);
> > +
> > +For a default policy customization:
> > +
> > +     pm_loss_shutdown_default_policy(struct pm_loss_policy *);
> > +
> > +3. Kernel configuration
> > +
> > +The following configuration options have been defined:
> > +
> > +    CONFIG_PM_LOSS     : this enables the generic pm_loss framework.
> > +    CONFIG_PM_LOSS_SIM : this adds the pwrfail_sim file to the sysfs interface
> > +		         and allows power loss events simulation.
> > +    CONFIG_PM_LOSS_DEBUG : this option enables some debug printk's .
> > +    CONFIG_PM_LOSS_TEST: this enables the compilation of a sample test module
> > +                         containing a customized default policy definition
> 
> OK, so I think that this feature may be kind of useful, but it will require
> some work before it's ready to go into the kernel.
> 
> Please separate the policy part for starters and let's see what's left.
> 
ok.

Thanks and regards
Davide
