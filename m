Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0CYMH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:07:27 -0400
Received: from daytona.panasas.com ([67.152.220.89]:36193 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753133Ab0CYMHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:07:21 -0400
Message-ID: <4BAB51F5.609@panasas.com>
Date: Thu, 25 Mar 2010 14:07:17 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <20100324163948.GR30031@ZenIV.linux.org.uk>	<4BAA48A3.1030801@panasas.com> <4BAA4CAC.6060104@panasas.com>	<4BAA5035.1060906@panasas.com> <4BAA52A8.2080304@panasas.com>	<20100324180622.GS30031@ZenIV.linux.org.uk>	<4BAA5955.4000001@gmail.com>	<20100324185604.GT30031@ZenIV.linux.org.uk>	<4BAB2F5A.30409@panasas.com>	<20100325101231.GU30031@ZenIV.linux.org.uk> <20100325105406.GW30031@ZenIV.linux.org.uk>
In-Reply-To: <20100325105406.GW30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 12:07:19.0759 (UTC) FILETIME=[B80A05F0:01CACC13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 25, 2010, 12:54 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, Mar 25, 2010 at 10:12:31AM +0000, Al Viro wrote:
>> On Thu, Mar 25, 2010 at 11:39:38AM +0200, Boaz Harrosh wrote:
>>
>>> It makes no difference, fails just the same. Would an "strace" help?
>> It might, especially if you ran it for identical repositories on local
>> fs and on NFS; at least that way it would be possible to see where do
>> they diverge...
> 
> I wonder...  What happens if you add
> 	if (error == -EISDIR)
> 		printk("blah: %s", pathname);
> right after do_lookup() call in do_last()?  That would separate -EISDIR
> coming from NFS from the same thing coming from fs/namei.c...

Bingo.
It is returned from do_lookup.

@@ -1648,6 +1654,8 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 	/* just plain open? */
 	if (!(open_flag & O_CREAT)) {
 		error = do_lookup(nd, &nd->last, path);
+		if (error == -EISDIR)
+			printk("%s: do_lookup returned -EISDIR %s\n", __func__, pathname);
 		if (error)
 			goto exit;
 		error = -ENOENT;


> _______________________________________________
> pNFS mailing list
> pNFS@linux-nfs.org
> http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs
