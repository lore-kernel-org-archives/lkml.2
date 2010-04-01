Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0DARWG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:22:06 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:32804 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab0DARV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:21:56 -0400
X-Greylist: delayed 957 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Apr 2010 13:21:55 EDT
To: Pavel Machek <pavel@ucw.cz>
Cc: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: webcam problem after suspend/hibernate
References: <45cc95261003301455u10e6ee24pfb66176bfb279d1@mail.gmail.com>
	<201003310125.26266.laurent.pinchart@ideasonboard.com>
	<v2x45cc95261003311251idfdc9b8anb7b2060618611d30@mail.gmail.com>
	<20100401165606.GA1677@ucw.cz>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 01 Apr 2010 10:05:52 -0700
In-Reply-To: <20100401165606.GA1677@ucw.cz>
Message-ID: <87aatn9k7j.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> > Do you mean the dmesg output ?
> > A full dmesg is included in this address :
> > http://pastebin.com/8XU619Uk
> > Not in all suspend/hibernate the problem comes, only in some of them
> > and this included dmesg output is just after a non working case of
> > webcam fault.
> > 
> > 
> > I also have found this in `/var/log/messages | grep uvcvideo`
> > Mar 31 00:31:16 linux-l365 kernel: [399905.714743] usbcore:
> > deregistering interface driver uvcvideo
> > Mar 31 00:31:24 linux-l365 kernel: [399914.121386] uvcvideo: Found UVC
> > 1.00 device LG Webcam (0c45:62c0)
> > Mar 31 00:31:24 linux-l365 kernel: [399914.135661] usbcore: registered
> > new interface driver uvcvideo
> 
> Also try unloading uvcvideo before suspend and reloading it after
> resume...

I have a similar problem with a Creative Optia webcam.

I have found that removing the ehci_hcd module and reinserting it
fixes the problem.

If your kernel ships with ehci_hcd built-in (F11 and later), the
script included also fixes the problem (it rebind the device).

Of course, I'd love to see this issue fixed.

Phil.

Script: /etc/pm/sleep.d/50kickuvc

#!/bin/sh

case "$1" in
  resume|thaw)
    cd /sys/bus/usb/drivers/uvcvideo || exit 1
    devices=''
    for i in [0-9]*-[0-9]*:*
    do
      [ -L "$i" ] || break
      saved_IFS="$IFS"
      IFS=:
      set -- $i
      IFS="$saved_IFS"
      found=no
      for j in $devices
      do
        if [ "$j" = "$1" ]
        then
          found=yes
        fi
      done
      if [ "$found" = no ]
      then
        devices="$devices $1"
      fi
    done
    if [ "$devices" != "" ]
    then
      cd /sys/bus/usb/drivers/usb || exit 1
      for i in $devices
      do
        echo $i > unbind
        sleep 1
        echo $i > bind
      done
    fi
    ;;
esac
