Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2KFMkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 07:40:49 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:42513
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab2KFMks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 07:40:48 -0500
Date: Tue, 6 Nov 2012 07:40:35 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Trond.Myklebust@netapp.com" <Trond.Myklebust@netapp.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3] SUNRPC: set desired file system root before
 connecting local transports
Message-ID: <20121106124035.GA20522@infradead.org>
References: <20121008105437.18668.99905.stgit@localhost.localdomain>
 <20121009193506.GA19680@fieldses.org>
 <5098E31A.5080801@parallels.com>
 <20121106120642.GA6718@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106120642.GA6718@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 07:06:42AM -0500, J. Bruce Fields wrote:
> On Tue, Nov 06, 2012 at 02:14:50PM +0400, Stanislav Kinsbursky wrote:
> > 09.10.2012 23:35, J. Bruce Fields ??????????:
> > >Cc'ing Eric since I seem to recall he suggested doing it this way?
> > >
> > >Seems OK to me, but maybe that swap_root should be in common code?  (Or
> > >maybe we could use set_fs_root()?)
> > >
> > 
> > This patch is not good since, as Eric mentioned, all kernel threads
> > share same fs struct.
> > We can swap whole fs struct. Or we can unshare fs struct
> > (unshare_fs_struct() is exported) and swap root in this case.
> > But this approach is to close to set_fs_root() logic, which is not
> > exported and seems there are some valid reasons for it.
> 
> What are those reasons?
> 
> Googling found one previous thread:
> 
> 	http://thread.gmane.org/gmane.linux.kernel/1259986/focus=47687
> 
> There Trond requests an ACK from Al or Cristoph for the export, but I
> don't see either an ACK or any objection.

I really don't think messing with current->fs for workqueue worker
threads is a good idea, as the worker threads are shared by different
workqueues and thus this can easily cause havoc for entirely unrelated
subsystems.

To do this properly you'll need to avoid current->fs references in the
sunrpc code.

And just in case it wasn't clear: the hack in this iteration is even
worse than the original.
