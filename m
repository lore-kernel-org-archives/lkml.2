Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0EMBbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 21:31:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab0EMBbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 21:31:40 -0400
Date: Wed, 12 May 2010 21:39:27 -0400
From: Josef Bacik <josef@redhat.com>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, hch@infradead.org,
       akpm@linux-foundation.org, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] new ->perform_write fop
Message-ID: <20100513013926.GD27011@dhcp231-156.rdu.redhat.com>
References: <20100512212403.GE3597@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100512212403.GE3597@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 05:24:04PM -0400, Josef Bacik wrote:
> Hello,
> 
> I just started adding aio_write to Btrfs and I noticed we're duplicating _alot_
> of the generic stuff in mm/filemap.c, even though the only thing thats really
> unique is the fact that we copy userspace pages in chunks rather than one page a
> t a time.  What would be best is instead of doing write_begin/write_end with
> Btrfs, it would be nice if we could just do our own perform_write instead of
> generic_perform_write.  This way we can drop all of these generic checks we have
> that we copied from filemap.c and just got to the business of actually writing
> the data.  I hate to add another file operation, but it would _greatly_ reduce
> the amount of duplicate code we have.  If there is no violent objection to this
> I can put something together quickly for review.  Thanks,
>

I just got a suggestion from hpa about instead just moving what BTRFS does into
the generic_perform_write.  What btrfs does is allocates a chunk of pages to
cover the entirety of the write, sets everything up, does the copy from user
into the pages, and tears everything down, so essentially what
generic_perform_write does, just with more pages.  I could modify
generic_perform_write and the write_begin/write_end aops to do this, where
write_begin will return how many pages it allocated, copy in all of the
userpages into the pages we allocated at once, and then call write_end with the
pages we allocated in write begin.  Then I could just make btrfs do
write_being/write_end.  So which option seems more palatable?  Thanks,

Josef 
