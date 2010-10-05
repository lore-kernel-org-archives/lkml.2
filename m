Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab0JESTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:19:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59544 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab0JESTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:19:44 -0400
Message-ID: <4CAB6C37.5010607@linux.vnet.ibm.com>
Date: Tue, 05 Oct 2010 11:19:35 -0700
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Eric Van Hensbergen <ericvh@gmail.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [V9fs-developer] [PATCH 1/3] fs/9p: Update TLCREATE to allow
 create without open
References: <1286298090-2422-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <AANLkTinpie0YLpiuJjv1RzYr4LN1HbdtXh=OoNNJbG6k@mail.gmail.com>
In-Reply-To: <AANLkTinpie0YLpiuJjv1RzYr4LN1HbdtXh=OoNNJbG6k@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/2010 10:15 AM, Eric Van Hensbergen wrote:
> Ouch.  Protocol change.
>
> Also - not sure I understand what's going on here.  Why does mknod go
> through TLCREATE, shouldn't we have our
> own protocol messages for mknod?//
>
> Why add an additional flag field instead of just using the existing
> flags field since we are only talking about a bit?
>
>      -eric
>
>
> On Tue, Oct 5, 2010 at 1:01 PM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com>  wrote:
>> We need this so that we can support regular file creation
>> with mknod
>>
>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>> ---
>>   fs/9p/v9fs.h            |    2 ++
>>   fs/9p/vfs_inode.c       |   13 +++++++------
>>   include/net/9p/client.h |    2 +-
>>   net/9p/client.c         |    6 +++---
>>   4 files changed, 13 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
>> index 8bb7792..6209a29 100644
>> --- a/fs/9p/v9fs.h
>> +++ b/fs/9p/v9fs.h
>> @@ -126,6 +126,8 @@ void v9fs_session_begin_cancel(struct v9fs_session_info *v9ses);
>>   #define V9FS_DEFUID    (-2)
>>   #define V9FS_DEFGID    (-2)
>>
>> +#define P9_LOOKUP_OPEN 0x1
>> +
>>   static inline struct v9fs_session_info *v9fs_inode2v9ses(struct inode *inode)
>>   {
>>         return (inode->i_sb->s_fs_info);
>> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
>> index 2f904a8..1ec9075 100644
>> --- a/fs/9p/vfs_inode.c
>> +++ b/fs/9p/vfs_inode.c
>> @@ -668,8 +668,9 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>>         int err = 0;
>>         char *name = NULL;
>>         gid_t gid;
>> -       int flags;
>> +       int flags = 0;
>>         mode_t mode;
>> +       int lookup_flags = 0;

I think we decided to send -1 with the flags instead of doing protocol change here.

Thanks,
JV

>>         struct v9fs_session_info *v9ses;
>>         struct p9_fid *fid = NULL;
>>         struct p9_fid *dfid, *ofid;
>> @@ -679,11 +680,10 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>>         struct posix_acl *pacl = NULL, *dacl = NULL;
>>
>>         v9ses = v9fs_inode2v9ses(dir);
>> -       if (nd&&  nd->flags&  LOOKUP_OPEN)
>> +       if (nd&&  nd->flags&  LOOKUP_OPEN) {
>>                 flags = nd->intent.open.flags - 1;
>> -       else
>> -               flags = O_RDWR;
>> -
>> +               lookup_flags = P9_LOOKUP_OPEN;
>> +       }
>>         name = (char *) dentry->d_name.name;
>>         P9_DPRINTK(P9_DEBUG_VFS, "v9fs_vfs_create_dotl: name:%s flags:0x%x "
>>                         "mode:0x%x\n", name, flags, omode);
>> @@ -713,7 +713,8 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
>>                            "Failed to get acl values in creat %d\n", err);
>>                 goto error;
>>         }
>> -       err = p9_client_create_dotl(ofid, name, flags, mode, gid,&qid);
>> +       err = p9_client_create_dotl(ofid, name, flags, mode,
>> +                                   gid, lookup_flags,&qid);
>>         if (err<  0) {
>>                 P9_DPRINTK(P9_DEBUG_VFS,
>>                                 "p9_client_open_dotl failed in creat %d\n",
>> diff --git a/include/net/9p/client.h b/include/net/9p/client.h
>> index fb358f5..b0b97ec 100644
>> --- a/include/net/9p/client.h
>> +++ b/include/net/9p/client.h
>> @@ -230,7 +230,7 @@ int p9_client_link(struct p9_fid *fid, struct p9_fid *oldfid, char *newname);
>>   int p9_client_symlink(struct p9_fid *fid, char *name, char *symname, gid_t gid,
>>                                                         struct p9_qid *qid);
>>   int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
>> -               gid_t gid, struct p9_qid *qid);
>> +                         gid_t gid, int lookup_flags, struct p9_qid *qid);
>>   int p9_client_clunk(struct p9_fid *fid);
>>   int p9_client_remove(struct p9_fid *fid);
>>   int p9_client_read(struct p9_fid *fid, char *data, char __user *udata,
>> diff --git a/net/9p/client.c b/net/9p/client.c
>> index 4b90b82..9950275 100644
>> --- a/net/9p/client.c
>> +++ b/net/9p/client.c
>> @@ -1070,7 +1070,7 @@ error:
>>   EXPORT_SYMBOL(p9_client_open);
>>
>>   int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
>> -               gid_t gid, struct p9_qid *qid)
>> +                         gid_t gid, int lookup_flags, struct p9_qid *qid)
>>   {
>>         int err = 0;
>>         struct p9_client *clnt;
>> @@ -1085,8 +1085,8 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
>>         if (ofid->mode != -1)
>>                 return -EINVAL;
>>
>> -       req = p9_client_rpc(clnt, P9_TLCREATE, "dsddd", ofid->fid, name, flags,
>> -                       mode, gid);
>> +       req = p9_client_rpc(clnt, P9_TLCREATE, "dsdddd", ofid->fid, name, flags,
>> +                           mode, gid, lookup_flags);
>>         if (IS_ERR(req)) {
>>                 err = PTR_ERR(req);
>>                 goto error;
>> --
>> 1.7.0.4
>>
>>
>> ------------------------------------------------------------------------------
>> Beautiful is writing same markup. Internet Explorer 9 supports
>> standards for HTML5, CSS3, SVG 1.1,  ECMAScript5, and DOM L2&  L3.
>> Spend less time writing and  rewriting code and more time creating great
>> experiences on the web. Be a part of the beta today.
>> http://p.sf.net/sfu/beautyoftheweb
>> _______________________________________________
>> V9fs-developer mailing list
>> V9fs-developer@lists.sourceforge.net
>> https://lists.sourceforge.net/lists/listinfo/v9fs-developer
>>
>
> ------------------------------------------------------------------------------
> Beautiful is writing same markup. Internet Explorer 9 supports
> standards for HTML5, CSS3, SVG 1.1,  ECMAScript5, and DOM L2&  L3.
> Spend less time writing and  rewriting code and more time creating great
> experiences on the web. Be a part of the beta today.
> http://p.sf.net/sfu/beautyoftheweb
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer


