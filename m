Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab0CWPm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:42:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39315 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384Ab0CWPm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:42:28 -0400
Message-ID: <4BA8E158.6040102@ti.com>
Date: Tue, 23 Mar 2010 10:42:16 -0500
From: Pavan Savoy <pavan_savoy@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: alan@lxorguk.ukuu.org.uk, pavan_savoy@ti.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers:misc: sources for ST core
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

comments inline...
 > +/* all debug macros go in here */
 > +#define ST_DRV_ERR(fmt, arg...)  printk(KERN_ERR "(stc):"fmt"\n" , 
## arg)
 > +#if defined(DEBUG)           /* limited debug messages */
 > +#define ST_DRV_DBG(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , 
## arg)
 > +#define ST_DRV_VER(fmt, arg...)
 > +#elif defined(VERBOSE)               /* very verbose */
 > +#define ST_DRV_DBG(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , 
## arg)
 > +#define ST_DRV_VER(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , 
## arg)
 > +#else /* error msgs only */
 > +#define ST_DRV_DBG(fmt, arg...)
 > +#define ST_DRV_VER(fmt, arg...)
 > +#endif

 >Use the existing debug macros

[pavan]
Wanted a module level debugging code - and hence the usage of these
debug macros. Like printing out of all UART data, etc..
Apparently most UART problems surfaced during firmware download in 
st_kim.c so the module level debug macros.
All printk's also do have their own KERN_ level already.
Will change it if you want it.


 > +/* function pointer pointing to either,
 > + * st_kim_recv during registration to receive fw download responses
 > + * st_int_recv after registration to receive proto stack responses
 > + */
 > +void (*st_recv) (const unsigned char *data, long count);

[alan]
 >What if you have multiple devices at once one in each state ?
 >Why is this global ?

[pavan]
st_gdata required in non-tty calls as well.

[pavan]
Can't happen, The chip on doing a UART write will either write whole of 
BT data or whole of FM, so it can't be in multiple states.

 > +     if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {

[alan]
 >Again shouldn't be using globals and needs to support multiple devices.
 >See the tty_struct - there is a field for an ldisc pointer, stuff
 >st_gdata in there at open time and pass tty around ?

[pavan]
st_gdata not in tty priv data or ldisc_data because there are entry 
points like st_register/unregister which are EXPORTed requires it.



 > +             ST_DRV_ERR("tty unavailable to perform write");
 > +             return ST_ERR_FAILURE;
 > +     }
 > +     tty = st_gdata->tty;

[alan]
 >Explain the locking on this NULL test - what stops it becoming NULL
 >between the if and the assignment ?

[pavan]
Calls to int_write in itself are safe, locked before being called.
Will recheck.
Up until now the same code has worked fine on UP and SMP.

[alan]
 >I think this code needs a fair bit of work at this point - locking,
 >supporting multiple devices at once etc.

 >Staging perhaps ?

[pavan]
If the rest seems fine, please consider it for staging,
Will keep reworking on it.


On Mon, 22 Mar 2010 14:35:30 -0700
Greg KH <gregkh@suse.de> wrote:

 > On Mon, Mar 22, 2010 at 04:19:12PM -0500, pavan_savoy@ti.com wrote:
 > > From: Pavan Savoy <pavan_savoy@ti.com>
 > >
 > > This change adds the Kconfig and Make file for TI's
 > > ST line discipline driver and the BlueZ driver for BT
 > > core of the TI BT/FM/GPS combo chip.
 > >
 > > Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
 > > ---
 > >  drivers/misc/Kconfig        |    1 +
 >
 > Why 'misc'?  Why not 'char' like all the other ldiscs?
 >
 > Or 'drivers/ldisc' to be more specific?

We've discussed having /tty or drivers/tty for a while. The ldiscs are
currently everywhere - drivers/net, isdn, char ....

I am not sure an ldisc directory helps though - slip and ppp are in
drivers/net for example and clearly belong there.
 >  #define N_V253               19      /* Codec control over voice 
modem */
 > +#define N_TI_SHARED  20      /* for TI's WL7 connectivity chips */

Be more specific or some future TI shared bus protocol might cause
confusion N_TI_WL7 sounds fine.

Alan
