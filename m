Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2IEHPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:15:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35007 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab2IEHPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:15:51 -0400
Message-ID: <5046FC22.3050509@gmail.com>
Date: Wed, 05 Sep 2012 15:15:46 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: yan yan <clouds.yan@gmail.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] proc: return -ENOMEM when inode allocation failed
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com> <1346681648-21427-2-git-send-email-clouds.yan@gmail.com> <50456F2E.6060408@gmail.com> <CAH+=+MG=9189mS7+Cb85-PV51EX1Df-zGmZ3u4YtSsEfmphYUQ@mail.gmail.com>
In-Reply-To: <CAH+=+MG=9189mS7+Cb85-PV51EX1Df-zGmZ3u4YtSsEfmphYUQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2012 05:22 PM, yan yan wrote:
> 2012/9/4 Cong Wang <xiyou.wangcong@gmail.com>:
>> On 09/03/2012 10:14 PM, yan wrote:
>>>
>>> Signed-off-by: yan <clouds.yan@gmail.com>
>>
>>
>> Please provide a changelog to explain why we need this patch.
>
> I think the title is self explained.
>
>
>>> ---
>>>    fs/proc/generic.c |    2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
>>> index b3647fe..9e8f631 100644
>>> --- a/fs/proc/generic.c
>>> +++ b/fs/proc/generic.c
>>> @@ -427,7 +427,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry
>>> *de, struct inode *dir,
>>>                  if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
>>>                          pde_get(de);
>>>                          spin_unlock(&proc_subdir_lock);
>>> -                       error = -EINVAL;
>>> +                       error = -ENOMEM;
>>
>>
>> Why the !memcmp() case is related with ENOMEM ??
>
> We are presetting 'error' here. The following proc_get_inode() will try
> to get an inode, either from inode cache or allocate a new one (and fill it).
>
> If we get a NULL inode, that means allocation failed. That's how
> ENOMEM involved.

Then the following patch is probably better than yours:


diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index b3647fe..6b22913 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -427,12 +427,16 @@ struct dentry *proc_lookup_de(struct 
proc_dir_entry *de, struct inode *dir,
                 if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
                         pde_get(de);
                         spin_unlock(&proc_subdir_lock);
-                       error = -EINVAL;
                         inode = proc_get_inode(dir->i_sb, de);
+                       if (!inode) {
+                               error = -ENOMEM;
+                               goto out_put;
+                       }
                         goto out_unlock;
                 }
         }
         spin_unlock(&proc_subdir_lock);
+
  out_unlock:

         if (inode) {
@@ -440,6 +444,8 @@ out_unlock:
                 d_add(dentry, inode);
                 return NULL;
         }
+out_put:
+
         if (de)
                 pde_put(de);
         return ERR_PTR(error);


