Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab0CYK4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:56:45 -0400
Received: from daytona.panasas.com ([67.152.220.89]:41403 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751976Ab0CYK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:56:44 -0400
Message-ID: <4BAB4168.2090404@panasas.com>
Date: Thu, 25 Mar 2010 12:56:40 +0200
From: Benny Halevy <bhalevy@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
References: <4BAA48A3.1030801@panasas.com> <4BAA4CAC.6060104@panasas.com> <4BAA5035.1060906@panasas.com> <4BAA52A8.2080304@panasas.com> <20100324180622.GS30031@ZenIV.linux.org.uk> <4BAA5955.4000001@gmail.com> <20100324185604.GT30031@ZenIV.linux.org.uk> <4BAB2F5A.30409@panasas.com> <20100325101231.GU30031@ZenIV.linux.org.uk> <4BAB3967.6000702@panasas.com> <20100325104924.GV30031@ZenIV.linux.org.uk>
In-Reply-To: <20100325104924.GV30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Mar 2010 10:56:43.0357 (UTC) FILETIME=[DAF260D0:01CACC09]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar. 25, 2010, 12:49 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Thu, Mar 25, 2010 at 12:22:31PM +0200, Benny Halevy wrote:
>> On Mar. 25, 2010, 12:12 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>>> On Thu, Mar 25, 2010 at 11:39:38AM +0200, Boaz Harrosh wrote:
>>>
>>>> It makes no difference, fails just the same. Would an "strace" help?
>>> It might, especially if you ran it for identical repositories on local
>>> fs and on NFS; at least that way it would be possible to see where do
>>> they diverge...
>>> _______________________________________________
>>> pNFS mailing list
>>> pNFS@linux-nfs.org
>>> http://linux-nfs.org/cgi-bin/mailman/listinfo/pnfs
>> ext3 fs exported on the server
>> client mount -t nfs4 localhost:/ /mnt/localhost
>> $ strace git status
>> ...
>> open(".git/objects/pack", O_RDONLY|O_NONBLOCK|O_DIRECTORY|0x80000) = -1 EISDIR (Is a directory)
> 
> Interesting.  It is a directory, indeed, but why the hell does that call
> fail with -EISDIR?
> 
> Does that happen with nfsv3 or is that v4-only?  I'm going to set up v4
> server and client and see what happens, but that information could be
> useful...

We've seen this with v4 only so far.

BTW I added this WARN_ON:
@@ -1656,8 +1659,10 @@ static struct file *do_last(struct nameidata *nd, struct path *path,
 		if (path->dentry->d_inode->i_op->follow_link)
 			return NULL;
 		error = -ENOTDIR;
-		if (*want_dir && !path->dentry->d_inode->i_op->lookup)
+		if (*want_dir && !path->dentry->d_inode->i_op->lookup) {
+			WARN_ON(1);
 			goto exit_dput;
+		}
 		path_to_nameidata(path, nd);
 		audit_inode(pathname, nd->path.dentry);
 		goto ok;

but it is NOT tripping for this scenario.

(for some reason I saw it tripping when building the kernel over nfs
but it's benign)

Benny
