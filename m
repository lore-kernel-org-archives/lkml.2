Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0DSMUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:20:37 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:41761 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331Ab0DSMUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:20:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=gZkp9dU0DdGxuEPMs6id746zr2MG3mgvhPdI2sy2YksbUjtxotwxGj3ScDRHaG1Iw1
         2OOHlobKhSAhKuuanvGEUmmCqUk7v3RdZgINeoy5+WCqAoGbHm1zlFLbut9d5Rfo0W5j
         +QwK2X2UuTprOVMP/TqHZRcdUbR1KZFYqbW+s=
MIME-Version: 1.0
Date: Mon, 19 Apr 2010 15:20:34 +0300
Message-ID: <k2h1ba2fa241004190520z5f048287v6f84e9117b04c803@mail.gmail.com>
Subject: request_firmware API exhaust memory
From: Tomas Winkler <tomasw@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       David Woodhouse <dwmw2@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lately we've been developing a device that rather more extensively
used request_firmware API in load and also using pm_notifiers to load
firmware. In some stress  testing the usage will exhaust the system
memory. First we suspected there is a memory leak in the
firwmare_class but eventually what is that udevd piles up it takes
time to collect the process. We loose ~ 500K for each
request/release_firmware iteration.
After the stress the process table will will look something like shown below,

If someone with more insight can point out what part of this firmware
load has to be fixed and what is the best strategy request_firmware
API used extensively.  I believe currently only Orinoco driver uses
pm_notifies to load firmware before S3/S4 but if there are more
drivers like that it might actually create a real problem during
suspend on some small systems.

root       514  0.0  0.0  15480  1116 ?        S<s  Apr01   0:01 /sbin/udevd -d
root     28989  0.0  0.0  15476   968 ?        S<   14:07   0:00 /sbin/udevd -d
root     28995  0.0  0.0  15476   976 ?        S<   14:07   0:00 /sbin/udevd -d
root     31616  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31622  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31627  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31633  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31638  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31644  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31649  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31655  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31660  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31666  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31671  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31677  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31682  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31688  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31693  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31699  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31704  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31710  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31715  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31721  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31726  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31732  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31737  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31743  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31748  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31754  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31759  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31765  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31770  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31776  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31781  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31787  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31792  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31798  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31803  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31809  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31814  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31820  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31825  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31831  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31836  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31842  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
root     31847  0.0  0.0  15476   916 ?        S<   14:49   0:00 /sbin/udevd -d
root     31853  0.0  0.0  15476   888 ?        S<   14:49   0:00 /sbin/udevd -d
