Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0KRMND (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 07:13:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42811 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0KRMNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 07:13:01 -0500
Date: Thu, 18 Nov 2010 13:12:56 +0100
From: "Dr. Werner Fink" <werner@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: tty: add 'active' sysfs attribute to tty0 and console device
Message-ID: <20101118121256.GA19884@boole.suse.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Greg KH <greg@kroah.com>, Lennart Poettering <mzxreary@0pointer.de>,
	Kay Sievers <kay.sievers@vrfy.org>, Valdis.Kletnieks@vt.edu,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Randy Dunlap <rdunlap@xenotime.net>, Jiri Slaby <jslaby@suse.cz>
References: <20101116225619.5fa7ef8b@lxorguk.ukuu.org.uk>
 <20101116231023.GB27594@tango.0pointer.de>
 <25482.1290031268@localhost>
 <AANLkTimV_zKK-Ubw3vJkDUtrYvB+W06cRR7Nz2vam6fP@mail.gmail.com>
 <20101117235647.00766e32@lxorguk.ukuu.org.uk>
 <20101118012734.GA8558@kroah.com>
 <20101118014848.GA7873@tango.0pointer.de>
 <20101118015310.GA30480@kroah.com>
 <20101118110020.GA13871@boole.suse.de>
 <20101118112335.434de53a@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20101118112335.434de53a@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 11:23:35AM +0000, Alan Cox wrote:
> > is the most pressing case e.g. on s390 or zSeries) and this without
> > forcing (and maybe stealing) the controlling tty on the system console
> > to be able to detect the primary tty/console.
> 
> What do you mean by console in this context
> 
> The console in printk context and the "console" in "active vt window" are
> unrelated concepts with the same name, so its a bit confusing to follow
> here. 

Example: running a boot script on /dev/console and after fsck
sulogin has to called to be able to asked the system admin.
Now the question is which console device the system admin is
waiting in front of (before /dev/ttyS0 or /dev/tty3270 or whatever).

> > facilities (having device, read, write, and unblank) are also shown
> > in the new file /sys/class/tty/console/active ... but maybe Randy
> > could says a few words for what this is usable.
> 
> The system console does not even need to be a tty device, and on many
> embedded devices is not (it may for example by a RAM buffer not wiped
> over reboots or it may be jtag or MIPI trace ports.
> 
> "tty0" is *currently* a shorthand for "the VT the keyboard/display are
> showing". That's a shorthand that in itself will make no sense in future.

I'm aware of.  For using tty devices of the system console it requires
to have e.g. with my patch:

  bash> cat /proc/tty/consoles 
  tty0                 -WU (ECp)       4:7

the `W' flag for write and the major:minor pair, beside this the `U'
flag indicates the tty can do an unblank operation, the `-' shows that
there is no read operation (never seen such a console tty).  On an other
system here I see:

  bash> cat /proc/tty/consoles
  ttyS0                -W- (ECp)       4:64
  tty0                 -WU (Ep)        4:1

which I'm using in user space with

    dev_t dev = 0;
    FILE * fc;

    if ((fc = fopen("/proc/tty/consoles", "r"))) {
        char fbuf[16];
        int maj, min;
        while ((fscanf(fc, "%*s %*s (%[^)]) %d:%d", &fbuf[0], &maj, &min) == 3)) {
            if (!strchr(fbuf, 'E'))
                continue;
            if (strchr(fbuf, 'C')) {
                dev = makedev(maj, min);
                break;
            }
        }
        fclose(fc);
    }

to detect the primary console device here.


       Werner

-- 
  "Having a smoking section in a restaurant is like having
          a peeing section in a swimming pool." -- Edward Burr
