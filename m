Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0IDMy5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 08:54:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65364 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0IDMy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 08:54:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=MTx5691miVxznDMiFAQFrFzAI99B7emXCWv08VJYiDuyx3jHZhmwlwcZlfHKbrBDxM
         Llv6CldE3DbhobP2RWnFFvPTaENCKZw/uUae/kjBA3qxXvirgr/BwVNrL1GhQN7Ba8vq
         9xVAVo3Y85ZDB2409LS5nao7ln1cYzZCwMWrs=
Message-ID: <4C82419C.3050903@suse.cz>
Date: Sat, 04 Sep 2010 14:54:52 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.8) Gecko/20100802 SUSE/3.1.2 Thunderbird/3.1.2
MIME-Version: 1.0
To: cjb@laptop.org
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: HIDDEV: potential NULL dereference
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've a question for you :). How could this patch help:

commit 7032269e87ade34cc12891675371fa2ac150a620
Author: Chris Ball <cjb@laptop.org>
Date:   Thu Aug 12 19:07:40 2010 -0400

    HID: hiddev: protect against disconnect/NULL-dereference race

    One of our users reports consistently hitting a NULL dereference that
    resolves to the "hid_to_usb_dev(hid);" call in hiddev_ioctl(), when
    disconnecting a Lego WeDo USB HID device from an OLPC XO running
    Scratch software.  There's a FIXME comment and a guard against the
    dereference, but that happens farther down the function than the
    initial dereference does.

    This patch moves the call to be below the guard, and the user reports
    that it fixes the problem for him.  OLPC bug report:
    http://dev.laptop.org/ticket/10174

    Signed-off-by: Chris Ball <cjb@laptop.org>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>






when the code now looks like:
  struct usb_device *dev; // here was the assignment before the patch
  struct usbhid_device *usbhid = hid->driver_data;
...
  if (!hiddev->exist || !hid)
    return -EIO;
  dev = hid_to_usb_dev(hid);


If hid was ever NULL at this phase, the check couldn't improve anything
due to hid->driver_data dereference being still before the check. So
again my question, how this could change anything?

Above that, it just makes the window shorter, but the bug is still
there, isn't it? Is the following scenario reasonable?

A (hiddev_ioctl)           | B
------------------------------------------------
if (!hid)                  |
  return -EIO;             |
                           | hid = NULL
                           | kfree(hid);
dev = hid_to_usb_dev(hid); |


Actually who's the process B you are trying to catch the race against by
the patch? hid-core?

thanks,
-- 
js
suse labs
