Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1AEXFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:05:30 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55056 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab1AEXF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:05:29 -0500
Message-ID: <4D24F934.7010803@linux.vnet.ibm.com>
Date: Wed, 05 Jan 2011 15:05:24 -0800
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Nick Piggin <npiggin@kernel.dk>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: linux-next: manual merge of the vfs-scale tree with the v9fs
 tree
References: <20110104124054.c767a4ee.sfr@canb.auug.org.au> <4D2363E7.30101@linux.vnet.ibm.com> <20110105064425.GA3161@amd>
In-Reply-To: <20110105064425.GA3161@amd>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/4/2011 10:44 PM, Nick Piggin wrote:
> On Tue, Jan 04, 2011 at 10:16:07AM -0800, Venkateswararao Jujjuri (JV) wrote:
>> On 1/3/2011 5:40 PM, Stephen Rothwell wrote:
>>> Hi Nick,
>>>
>>> Today's linux-next merge of the vfs-scale tree got a conflict in
>>> fs/9p/vfs_inode.c between commit 3d21652a1d23591e7f0bbbbedae29ce78c2c1113
>>> ("fs/9p: Move dotl inode operations into a seperate file") from the v9fs
>>> tree and various commits from the vfs-scale tree.
>>>
>>> I fixed it up by using the v9fs changes to that file and then applying
>>> the following merge fixup patch (which I can carry as necessary).
>>>
>>> Someone will need to fix this up before one of these trees is merged by
>>> Linus, or to send this merge fix to Linus.
>>>
>>> From: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Date: Tue, 4 Jan 2011 12:33:54 +1100
>>> Subject: [PATCH] v9fs: merge fix for changes in the vfs-scale tree
>>>
>>> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> ---
>>>  fs/9p/vfs_inode_dotl.c |   22 +++++++++++-----------
>>>  1 files changed, 11 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
>>> index 38d5880..9dd534b 100644
>>> --- a/fs/9p/vfs_inode_dotl.c
>>> +++ b/fs/9p/vfs_inode_dotl.c
>>> @@ -78,11 +78,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
>>>  {
>>>  	struct dentry *dentry;
>>>
>>> -	spin_lock(&dcache_lock);
>>> +	spin_lock(&inode->i_lock);
>>>  	/* Directory should have only one entry. */
>>>  	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
>>>  	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
>>> -	spin_unlock(&dcache_lock);
>>> +	spin_unlock(&inode->i_lock);
>>
>> Are we doing away with dcache_lock?
> 
> It's on its last legs...
> 
> 
>> I am not sure if the i_lock can serve the same purpose..but looks like with the
>> current code
>> there may not need any lock around this code. Aneesh/Eric do you guys have any
>> comments?
> 
> Well first of all, why do you say i_lock can't serve the same purpose?

What I mean is i_lock is not equivalent to dcache_lock in generic sense.

> Removing locks is well and good, but if i_lock doesn't work here, then
> I've made a mistake either fudnamentally in the dcache, or with a
> particular pattern that v9fs uses -- either way it has to be understood.
> 

Initially we had a version where we walk up the d_parent to construct
the complete path and corresponding fids for the entire path for 9P purpose.
As we are walking we thought of using big hammer to lock the entire dcache.
Later we used read/write locks to protect race between v9fs_fid_lookup and
rename operations.
Hence I don't think we need to protect this with  dcache_lock.
But having i_lock around this code looks good to me.

> dcache lock removal of course isn't done ad-hoc. These two patches
> specifically are the ones which aim to replace this particular instance
> of locking:

While reading patches below...
> 
> http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commit;h=5d30c20d47023b95b2a0d4820917dba8ba218d1a

@@ -271,9 +271,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct
inode *inode)
        struct dentry *dentry;

        spin_lock(&dcache_lock);
+       spin_lock(&dcache_inode_lock);
        /* Directory should have only one entry. */
        BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
        dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
+       spin_unlock(&dcache_inode_lock);
        spin_unlock(&dcache_lock);
        return dentry;
> http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commit;h=ef4953a772e04aef8cf5b94a9b70ffbb12b576e2
> 
@@ -277,11 +277,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct
inode *inode)
 {
        struct dentry *dentry;

-       spin_lock(&dcache_inode_lock);
+       spin_lock(&inode->i_lock);
        /* Directory should have only one entry. */
        BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
        dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
-       spin_unlock(&dcache_inode_lock);
+       spin_unlock(&inode->i_lock);
        return dentry;
 }

Wondering if there is another patch in between to take out the dcache_lock.

Anyway, Changes in this patch look good to me and sorry for the confusion.

Thanks,
JV
> 
>>>  	return dentry;
>>>  }
>>>
>>> @@ -215,7 +215,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>>>  				err);
>>>  			goto error;
>>>  		}
>>> -		dentry->d_op = &v9fs_cached_dentry_operations;
>>> +		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
>>
>> Assuming that this is a macro to the same operation.. rest of the changes look
>> fine to me.
> 
> Yes it's equivalent.
> 
> Thanks,
> Nick
> 


