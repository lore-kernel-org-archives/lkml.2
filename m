Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab1IZM6Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 08:58:24 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:40858 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1IZM6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 08:58:23 -0400
Message-ID: <4E807713.5060401@free-electrons.com>
Date: Mon, 26 Sep 2011 14:58:59 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCHv6] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>	 <1316678312-8913-1-git-send-email-david.wagner@free-electrons.com> <1316775538.19921.19.camel@sauron>
In-Reply-To: <1316775538.19921.19.camel@sauron>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/23/2011 12:58 PM, Artem Bityutskiy wrote:
[...]
> 2. Please, could you explain what prevents the following crash/issue:
> 
> modprobe ubiblk volumes=0:0
> mkfs.ext3 /dev/ubiblk0
> mount -t ext3 /dev/ubiblk0 /mnt/fs
> rmmod ubiblk
> 
> Not that I think this is a problem, I just do not realize what would
> prevent ubiblk from being unloaded when it is mounted. Did you test this
> scenario?

I forgot to address this in the v7, so:

The kernel has an internal refcounter for each module.  It increases
with each module that uses it and for each open device owned by it.

In the case of ubiblk, we have:
static const struct block_device_operations ubiblk_ops = {
        .owner = THIS_MODULE,
        .open = ubiblk_open,
        .release = ubiblk_release,
};

The "owner" field makes ubiblk devices owned by ubiblk, so each open
device increases the refcounting and if the user tries to rmmod ubiblk
when there are still open ubiblk devices, it will get an EBUSY error.


	Regards,
	David.

-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
