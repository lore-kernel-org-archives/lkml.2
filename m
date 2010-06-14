Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab0FNORr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:17:47 -0400
Received: from eriks.xs4all.nl ([83.160.41.216]:54769 "EHLO eriks.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab0FNORq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:17:46 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jun 2010 10:17:46 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=slagter.name; h=subject:from
	:to:content-type:date:message-id:mime-version
	:content-transfer-encoding; q=dns; s=2007072601; b=EJ554BUr9VFEF
	RzGNcX70Vp3p8WEmte7wWHKcOTTmu4AeFDWo1XmgEI2Z7vaFdG+4hnoEBQlkSarQ
	QZgGwRi2ciOLdBQm8tjW3xRhdRv4Ll5JeeNY8UxV2nuGeHOhMTNtZ98fvWogAZ0g
	l7RDBKQ9r3AdKxTB4bQEsrkgIASKwM=
Subject: Help with pdflush latency / congestion on older kernel (2.6.18)
From: Erik Slagter <erik@slagter.name>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Jun 2010 16:03:17 +0200
Message-ID: <1276524197.2036.45.camel@autems.0.0.sb.ka.wlz.nl>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

First of all I must apologise that this relates to an older kernel
version. This kernel is used on a satellite top-box with a closed source
module of it's vendor that handles the specific hardware, so we cannot
use a new kernel, sadly. The good news is that the problem has nothing
to do with the closed source module. I was hoping that maybe this is a
known problem and has been fixed in newer kernel version and so I can
try to backport it (or maybe that has already been done...)

This is the problem. Until recently a 2.6.9 kernel was used (yep, I
hesitate to admit...) The vendor now switched to 2.6.18 and since then
we have a sort of disk write congestion problem, at least on NFS but
maybe also on local (ata) disks. It appears that pdflush waits too long
before it starts writing the dirty pages, which results in the processes
that fetch and write the data, are being blocked at a certain point. In
the meantime, data keeps coming in (satellite tv being notorious for
it's lack of flow control ;-)) and the hardware and/or os level queues
overflow, because they're not fetched in time. This is especially true
when more than one recording takes place and/or a simultaneous playback
takes place.

I think changing the user space process (like using additional threads)
will not solve the problem completely and also would be rather a
workaround instead.

We've done lot's of testing and tweaking in the meantime, detailed
information is available at request!

Things we tried already:
 - various incantations of posix_fadvise on the file to be written, only
once or on a frequent base (posix_fadvise(...DONT_NEED...))
 - opening using O_SYNC
 - tweaking /proc/vm/: dirty_background_ratio, dirty_expire_centisecs, 
dirty_ratio, dirty_writeback_centisecs

It appears that dirty_writeback_centisecs cannot be set to any value
below 5 seconds. We believe that the possibility to wake up pdflush
earlier actually would help in this case.

Would using O_DIRECT be a possible solution? I cannot test that at the
moment though, because the out-of-the-box doesn't have it enabled in the
config, but I probably can get hold a kernel that has it enabled.

Can anyone supply some help, clues, hints, tips, etc., it's very much
appreciated! Thanks very much!

