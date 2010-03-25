Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab0CYMTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:19:03 -0400
Received: from daytona.panasas.com ([67.152.220.89]:15000 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751133Ab0CYMTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:19:00 -0400
Message-ID: <4BAB54B0.3080109@panasas.com>
Date: Thu, 25 Mar 2010 14:18:56 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
CC: pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com>	<4BAA4CAC.6060104@panasas.com>	<4BAA5035.1060906@panasas.com>	<4BAA52A8.2080304@panasas.com>	<20100324180622.GS30031@ZenIV.linux.org.uk>	<4BAA5955.4000001@gmail.com>	<20100324185604.GT30031@ZenIV.linux.org.uk>	<4BAB2F5A.30409@panasas.com>	<20100325101231.GU30031@ZenIV.linux.org.uk>	<20100325105406.GW30031@ZenIV.linux.org.uk> <4BAB51F5.609@panasas.com>
In-Reply-To: <4BAB51F5.609@panasas.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 12:18:59.0248 (UTC) FILETIME=[58F79300:01CACC15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 25, 2010, 14:07 +0200, Benny Halevy <bhalevy@panasas.com> wrote:
> On Mar. 25, 2010, 12:54 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>> On Thu, Mar 25, 2010 at 10:12:31AM +0000, Al Viro wrote:
>>> On Thu, Mar 25, 2010 at 11:39:38AM +0200, Boaz Harrosh wrote:
>>>
>>>> It makes no difference, fails just the same. Would an "strace" help?
>>> It might, especially if you ran it for identical repositories on local
>>> fs and on NFS; at least that way it would be possible to see where do
>>> they diverge...
>> I wonder...  What happens if you add
>> 	if (error == -EISDIR)
>> 		printk("blah: %s", pathname);
>> right after do_lookup() call in do_last()?  That would separate -EISDIR
>> coming from NFS from the same thing coming from fs/namei.c...
> 
> Bingo.
> It is returned from do_lookup.

Indeed this error is coming from the server:

nfsd_dispatch: vers 4 proc 1                                                                            
nfsv4 compound op #1/7: 22 (OP_PUTFH)                                                                   
nfsd: fh_verify(16: 01010001 00000000 000e6592 345b9f25 00000000 00000000)                              
nfsv4 compound op ffff880076734078 opcnt 7 #1: 22: status 0                                             
nfsv4 compound op #2/7: 32 (OP_SAVEFH)                                                                  
nfsv4 compound op ffff880076734078 opcnt 7 #2: 32: status 0                                             
nfsv4 compound op #3/7: 18 (OP_OPEN)                                                                    
NFSD: nfsd4_open filename pack op_stateowner (null)                                                     
renewing client (clientid 4bab503e/00000002)                                                            
nfsd: nfsd_lookup(fh 16: 01010001 00000000 000e6592 345b9f25 00000000 00000000, pack)                   
nfsd: fh_verify(16: 01010001 00000000 000e6592 345b9f25 00000000 00000000)                              
nfsd: fh_compose(exp 08:05/106497 objects/pack, ino=943508)                                             
nfsd: fh_verify(16: 01010001 00000000 000e6594 345b9f26 00000000 00000000)                              
nfsv4 compound op ffff880076734078 opcnt 7 #3: 18: status 21                                            
nfsv4 compound returned 21                                                                              

> 
> @@ -1648,6 +1654,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
>  	/* just plain open? */
>  	if (!(open_flag & O_CREAT)) {
>  		error = do_lookup(nd, &nd->last, path);
> +		if (error == -EISDIR)
> +			printk("%s: do_lookup returned -EISDIR %s\n", __func__, pathname);
>  		if (error)
>  			goto exit;
>  		error = -ENOENT;
> 
> 
>> _______________________________________________
>> pNFS mailing list
>> pNFS@linux-nfs.org
>> http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs
> _______________________________________________
> pNFS mailing list
> pNFS@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs
