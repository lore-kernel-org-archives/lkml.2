Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0IVTbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 15:31:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51693 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379Ab0IVTbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 15:31:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=CVOy+v/lQqc9NcpJxiLm+u4H03h020/851Jo1NZ/SFcoanrQWy0c20ZRuYYvZ9KGD
	sWtqmn+lq2pDV86+t+zNQ==
Date: Wed, 22 Sep 2010 12:31:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] sysfs: Fail bin file mmap if vma close is
 implemented.
In-Reply-To: <m1zkvc26hg.fsf@fess.ebiederm.org>
Message-ID: <alpine.LSU.2.00.1009221215250.29127@tigran.mtv.corp.google.com>
References: <m1aanc3l3e.fsf@fess.ebiederm.org> <m1zkvc26hg.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Sep 2010, Eric W. Biederman wrote:
> 
> It is not reasonably possible to wrap vma->close().  To correctly
> wrap close would imply calling close on any vmas that remain when
> sysfs_remove_bin_file is called.  Finding the proper lists walking
> them getting the locking right etc, requires deep knowledge of the
> mm subsystem and as such would require assistence from the mm
> subsystem to implement.  That assistence does not currently exist.

Isn't it fair to assume that the call to sysfs_remove_bin_file() would
come from the module (or whatever) that would be handling the ->mmap,
->open, ->close, ->fault etc. calls?

In which case, it has been kept up to date with the reference counting
so far: and if it judges that it's apppropriate now to remove bin file,
despite having received more mmaps and opens than closes, then I think
it should be allowed to make that decision (knowing that your sysfs end
will take care not to call it further), even though it wanted to support
close while the sysfs bin file was still there.

I think it would be nicer to leave the bin_vma_close() handling as you
had it before (but repositioning its sysfs_get_active more carefully,
as in your 2/2).

Hugh
