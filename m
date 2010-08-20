Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0HTLwB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:52:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35583 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab0HTLv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:51:58 -0400
Date: Fri, 20 Aug 2010 12:51:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, adilger@sun.com,
        corbet@lwn.net, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V18 04/13] vfs: Allow handle based open on symlinks
Message-ID: <20100820115135.GQ31363@ZenIV.linux.org.uk>
References: <1282269097-26166-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1282269097-26166-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20100820083057.GA10039@infradead.org>
 <20100820195303.20b17210@notabene>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820195303.20b17210@notabene>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 07:53:03PM +1000, Neil Brown wrote:
> On Fri, 20 Aug 2010 04:30:57 -0400
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > Suddenly getting an file pointer for a symlink which could never happen
> > before is a really bad idea.  Just add a proper readlink_by_handle
> > system call, similar to what's done in the XFS interface.
> 
> Why is that?
> With futexes we suddenly get a file descriptor for something we could never
> get a file descriptor on before and that doesn't seem to be a problem.
> 
> Why should symlinks be special as the only thing that you cannot have a file
> descriptor for?  Uniformity of interface is a very valuable property.

You are welcome to review the codepaths around pathname resolution for
assumptions of presense of ->follow_link() and friends; there _are_
subtle cases and dumping your "opened symlinks" in there is far from
a trivial change.  Note that it affects more than just the starting
points of lookups; /proc/*/fd/* stuff is also involved.

BTW, speaking of NULL pathname, linkat() variant that allows creating a link
to an opened file is also a very dubious thing; at the very least, you get
non-trivial security implications, since now a process that got an opened
descriptor passed to it by somebody else may create hardlinks to the sucker.
