Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2D1OTt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 10:19:49 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:36892 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab2D1OTr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 10:19:47 -0400
Date: Sat, 28 Apr 2012 10:19:33 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 15/23] jbd2: Change disk layout for metadata
 checksumming
Message-ID: <20120428141933.GB29481@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
 <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306204941.1663.56283.stgit@elm3b70.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 12:49:41PM -0800, Darrick J. Wong wrote:
> @@ -177,11 +189,17 @@ typedef struct journal_block_tag_s
>  	__be32		t_blocknr;	/* The on-disk block number */
>  	__be32		t_flags;	/* See below */
>  	__be32		t_blocknr_high; /* most-significant high 32bits. */
> +	__be32		t_checksum;	/* crc32c(uuid+seq+block) */
>  } journal_block_tag_t;
>  
>  #define JBD2_TAG_SIZE32 (offsetof(journal_block_tag_t, t_blocknr_high))
>  #define JBD2_TAG_SIZE64 (sizeof(journal_block_tag_t))

There's a problem with this patch here --- we are changing the size of
journal_block_tag_t, which is an on-disk data structure.  So for
64-bit journals, this represents a format change.  This means that if
you have a 64-bit file system that needs to have its journal
recovered, if the journal was written with an older kernel, and then
we try to recover it with a new kernel, things won't be good.
Similarly, for e2fsck's recovery code, it's not going to be able to
recover 64-bit file systems using current coding, since this patch
series changes the size of JBD2_TAG_SIZE64.

What we need to do is something like this:

#define JBD2_TAG_SIZE64 (offsetof(journal_block_tag_t, t_checksum))
#define JBD2_TAG_SIZE_CSUM (sizeof(journal_block_tag_t))

And then change the code appropriately in e2fsprogs and in the kernel
to use the correct tag size depending on the journal options.

       	   	       	    	      	     - Ted
