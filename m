Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab0CYNGQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:06:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50156 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204Ab0CYNGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:06:13 -0400
Date: Thu, 25 Mar 2010 13:06:10 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325130610.GZ30031@ZenIV.linux.org.uk>
References: <4BAA5035.1060906@panasas.com>
 <4BAA52A8.2080304@panasas.com>
 <20100324180622.GS30031@ZenIV.linux.org.uk>
 <4BAA5955.4000001@gmail.com>
 <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
 <20100325105406.GW30031@ZenIV.linux.org.uk>
 <4BAB51F5.609@panasas.com>
 <4BAB54B0.3080109@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB54B0.3080109@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 02:18:56PM +0200, Benny Halevy wrote:

> Indeed this error is coming from the server:
> 
> nfsd_dispatch: vers 4 proc 1                                                                            
> nfsv4 compound op #1/7: 22 (OP_PUTFH)                                                                   
> nfsd: fh_verify(16: 01010001 00000000 000e6592 345b9f25 00000000 00000000)                              
> nfsv4 compound op ffff880076734078 opcnt 7 #1: 22: status 0                                             
> nfsv4 compound op #2/7: 32 (OP_SAVEFH)                                                                  
> nfsv4 compound op ffff880076734078 opcnt 7 #2: 32: status 0                                             
> nfsv4 compound op #3/7: 18 (OP_OPEN)                                                                    
> NFSD: nfsd4_open filename pack op_stateowner (null)                                                     
> renewing client (clientid 4bab503e/00000002)                                                            
> nfsd: nfsd_lookup(fh 16: 01010001 00000000 000e6592 345b9f25 00000000 00000000, pack)                   
> nfsd: fh_verify(16: 01010001 00000000 000e6592 345b9f25 00000000 00000000)                              
> nfsd: fh_compose(exp 08:05/106497 objects/pack, ino=943508)                                             
> nfsd: fh_verify(16: 01010001 00000000 000e6594 345b9f26 00000000 00000000)                              
> nfsv4 compound op ffff880076734078 opcnt 7 #3: 18: status 21                                            
> nfsv4 compound returned 21                                                                              

Ho-hum...  So it hits the "let's try to open it atomically" path and
gets told to FOAD by server (as it should, of course).

And if we see different behaviour after ls -l, presumably that's a
difference between ->lookup() and ->d_revalidate() paths on client...

OK, I think I see what's going on in this case.  However, it doesn't
explain everything; my current theory is that we used to get LOOKUP_DIRECTORY
on the last components in O_DIRECTORY opens and we don't do that now.
That used to derail the is_atomic_open(), now it's hit and there we go.

It's not hard to verify (and it might take care of this testcase), but
I still have questions about the way this code used to work *without*
O_DIRECTORY.

Let's try this: before do_lookup() call there add
	if (*want_dir)
		nd->flags |= LOOKUP_DIRECTORY;
and see how does it behave.

However, even if it does help, it doesn't explain everything.  Normal
open() on a directory without O_DIRECTORY if flags shouldn't fail with
-EISDIR.  How did that manage to avoid it all along?
