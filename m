Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab2HQWLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 18:11:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35327 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab2HQWK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 18:10:56 -0400
Message-ID: <502EC16C.4030007@wwwdotorg.org>
Date: Fri, 17 Aug 2012 16:10:52 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Will Drewry <wad@chromium.org>,
        "cross-distro@lists.linaro.org" <cross-distro@lists.linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: root=PARTUUID for MBR/NT disk signatures?
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was considering extending the kernel command-line option
root=PARTUUID= to also support MBR (NT disk signatures). I was thinking
of a syntax along the lines of:

root=PARTUUID=UUUUUUUU-PP[/PARTNROFF=%d]

... where UUUUUUUU is the hex representation of the NT disk signature,
and PP is the hex representation of the partition number. Like GPT,
/PARTNROFF could be used too if desired.

Related, I was thinking of changing struct partition_meta_info's uuid
field to be a string, so that it could simply be strcmp'd against the
UUID value on the kernel command-line. That way, the type of the UUID is
irrelevant.

Does anyone have any objection to that?

The reason I aim for that syntax rather than say:

root=MBRSIG=UUUUUUUU-PP[/PARTNROFF=%d]

... is to allow boot-loaders (e.g. U-Boot on ARM) to store just the
partition ID in a variable, and prepend all the Linux-specific stuff on
the front, e.g.

# For GPT:
setenv kernel_part_uuid b2f82cda-2535-4779-b467-094a210fbae7
# For MBR:
setenv kernel_part_uuid UUUUUUUU-PP

In fact, those hard-coded statements would probably be replaced with a
run-time command:

part uuid mmc 0:1 kernel_part_uuid

# Then in a common script:
setenv bootargs root=PARTUUID=${kernel_part_uuid}

Otherwise, the value of the uuid variable (or result of the "part uuid"
command) would need to prepend the PARTUUID= or MBRSIG= to the "uuid"
variable's value, and that's probably Linux-specific rather than part of
a generic UUID for the partition.
