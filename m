Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2AWUEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:04:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2AWUEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:04:09 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Niels de Vos <ndevos@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Bryn M. Reeves" <bmr@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v2] fs: Invalidate the cache for a parent block-device if fsync() is called for a partition
References: <4F19356E.3020708@redhat.com>
	<1327315109-7740-1-git-send-email-ndevos@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 23 Jan 2012 15:04:07 -0500
In-Reply-To: <1327315109-7740-1-git-send-email-ndevos@redhat.com> (Niels de
	Vos's message of "Mon, 23 Jan 2012 10:38:29 +0000")
Message-ID: <x49ehuq9oeg.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Niels de Vos <ndevos@redhat.com> writes:

> Executing an fsync() on a file-descriptor of a partition flushes the
> caches for that partition by calling blkdev_issue_flush(). However, it
> seems that reading data through the parent device will still return the
> old cached data.

You are mixing up two different caches.  blkdev_issue_flush flushes the
hard disk's cache, if it exists, and is advertised as a write-back
cache.  The cache that doesn't get flushed is the page cache, since you
are accessing the same disk blocks via different devices (the whole
device and the partition).

Nevertheless, the fix looks fine to me.  There shouldn't be much cached
for the whole block device if there are partitions, so this shouldn't
generate an I/O storm or flush out buffers that are otherwise useful.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
