Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab0C2TDM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 15:03:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51251 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0C2TDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 15:03:09 -0400
Date: Mon, 29 Mar 2010 20:03:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-nfs@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.34-rc2 NFS4 oops] open error path failure...
Message-ID: <20100329190307.GJ30031@ZenIV.linux.org.uk>
References: <6278d2221003291136p6481fe8emfb039403343c082@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6278d2221003291136p6481fe8emfb039403343c082@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 07:36:45PM +0100, Daniel J Blueman wrote:
> Hi Trond,
> 
> When open fails and should return EPERM [1], instead we see an oops
> [2]. I see this on 2.6.34-rc1 and -rc2 mainline; NFS4 server is
> mainline 2.6.33.1.
> 
> Let me know if you can't reproduce it and I'll provide some analysis
> from this end.

Joy...  ERR_PTR(-EPERM) in nd.intent.file, and whoever had called
lookup_instantiate_filp() hadn't bothered to check the return value.

OK, I think I see what's going on.  Replace
                                lookup_instantiate_filp(nd, (struct dentry *)state, NULL);
                                return 1;
with
                                lookup_instantiate_filp(nd, (struct dentry *)state, NULL);
                                return state;
in fs/nfs/nfs4proc.c:nfs4_open_revalidate() and see if everything works
properly (or just lose the lookup_instantiate_filp() in there and simply
return state).

