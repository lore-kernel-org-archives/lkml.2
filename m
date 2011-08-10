Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1HJLYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:24:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33408 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab1HJLYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:24:39 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Johannes Weiner <jweiner@redhat.com>, fuse-devel@lists.sourceforge.net,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] fuse: delete dead .write_begin and .write_end aops
References: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
	<20110725204942.GA12183@infradead.org>
	<87aabkeyfj.fsf@tucsk.pomaz.szeredi.hu>
	<20110810102604.GB6117@infradead.org>
Date: Wed, 10 Aug 2011 13:24:36 +0200
In-Reply-To: <20110810102604.GB6117@infradead.org> (Christoph Hellwig's
	message of "Wed, 10 Aug 2011 06:26:04 -0400")
Message-ID: <87sjp97bm3.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Mon, Aug 08, 2011 at 05:05:20PM +0200, Miklos Szeredi wrote:
>> > The loop code still calls them uncondtionally.  This actually is a big
>> > as write_begin and write_end require filesystems specific locking,
>> > and might require code in the filesystem to e.g. update the ctime
>> > properly.  I'll let Miklos chime in if leaving them in was intentional,
>> > and if it was a comment is probably justified.
>> 
>> Loop checks for ->write_begin() and falls back to ->write if the former
>> isn't defined.
>> 
>> So I think the patch is fine.  I tested loop over fuse, and it still
>> works after the patch.
>
> It works, but it involves another data copy, which will slow down
> various workloads that people at least historically cared about.

AFAICS, normally there isn't an additional copy.  If ->write_begin is
defined the copy from the bio_vec to the filesystem page is done with
transfer_none() in the loop driver.

Otherwise the copy is done by ->write() itself on the kmapped bio.

If there's a crypto transfer function then a temporary page will be used
in the no write_begin case.  But I don't think there the additional copy
makes much difference or that anyone cares.

Thanks,
Miklos
