Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487Ab2H1ReY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:34:24 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:52612 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab2H1ReU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:34:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>,
        Dmitry Monakhov <dmonakhov@openvz.org>, Abhijith Das <adas@redhat.com>
References: <87lih2h6i4.fsf@xmission.com> <87harqecvk.fsf@xmission.com>
	<20120827085034.GA8998@quack.suse.cz> <87wr0j7u3j.fsf_-_@xmission.com>
	<20120828090544.GC5146@quack.suse.cz>
Date: Tue, 28 Aug 2012 10:34:04 -0700
In-Reply-To: <20120828090544.GC5146@quack.suse.cz> (Jan Kara's message of
	"Tue, 28 Aug 2012 11:05:44 +0200")
Message-ID: <87a9xe7wfn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18PvD+liTGezcybxHjETiyDbs59NWSJh04=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2189]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] userns: Add basic quota support v2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> On Mon 27-08-12 17:12:16, Eric W. Biederman wrote: 
>> Add the data type struct qown which holds the owning identifier of a
>> quota.  struct qown is a replacement for the implicit union of uid,
>> gid and project stored in an unsigned int and the quota type field
>> that is was used in the quota data structures.  Making the data type
>> explicit allows the kuid_t and kgid_t type safety to propogate more
>> thoroughly through the code, revealing more places where uid/gid
>> conversions need be made.
>> 
>> Allong with the data type struct qown comes the helper functions
>   ^^^^ Along
>
>> qown_eq, qown_lt, from_qown, from_qown_munged, qown_valid, make_qown,
>> make_qown_invalid, make_qown_uid, make_qown_gid.
>> 
>> Replace struct dquot dq_id and dq_type with dq_own a struct qown.
>> 
>> Update the signature of dqget, quota_send_warning, dquot_get_dqblk,
>> and dquot_set_dqblk to use struct qown.
>> 
>> Make minimal changes to ext3, ext4, gfs2, ocfs2, and xfs to deal with
>> the change in quota structures and signatures.  The ocfs2 changes are
>> larger than most because of the extensive tracing throughout the ocfs2
>> quota code that prints out dq_id.
>> 
>> v2:
>>  - Renamed qown_t struct qown
>>  - Added the quota type to struct qown.
>>  - Removed enum quota_type (In this patch it was just noise)
>>  - Added qown_lt, make_qown_invalid, make_qown_uid, make_qown_gid
>>  - Taught qown to handle xfs project ids (but only in init_user_ns). 
>>    Q_XGETQUOTA calls .get_quotblk with project ids.
>   Just a couple one minor comments below...
>
>> @@ -130,13 +130,17 @@ static void copy_to_if_dqblk(struct if_dqblk *dst, struct fs_disk_quota *src)
>>  static int quota_getquota(struct super_block *sb, int type, qid_t id,
>>  			  void __user *addr)
>>  {
>> +	struct qown qown;
>>  	struct fs_disk_quota fdq;
>>  	struct if_dqblk idq;
>>  	int ret;
>>  
>>  	if (!sb->s_qcop->get_dqblk)
>>  		return -ENOSYS;
>> -	ret = sb->s_qcop->get_dqblk(sb, type, id, &fdq);
>> +	qown = make_qown(current_user_ns(), type, id);
>> +	if (qown_valid(qown))
>             ^ missing '!'

Good catch thank you.  

>> +		return -EINVAL;
>> +	ret = sb->s_qcop->get_dqblk(sb, qown, &fdq);
>>  	if (ret)
>>  		return ret;
>>  	copy_to_if_dqblk(&idq, &fdq);
> ...
>> +static inline u32 from_qown(struct user_namespace *user_ns, struct qown qown)
>> +{
>> +	switch (qown.type) {
>> +	case USRQUOTA:
>> +		return from_kuid(user_ns, qown.uid);
>> +	case GRPQUOTA:
>> +		return from_kgid(user_ns, qown.gid);
>> +	case XQM_PRJQUOTA:
>> +		return (user_ns == &init_user_ns) ? qown.prj : -1;
>> +	default:
>> +		BUG();
>> +	}
>> +}
>   I would like a bit more if the function somehow expressed in its name
> that it returns id. id_from_qown() might be a bit too long given how often
> it is used. qown2id() would be OK but it would be inconsistent with how
> names of other functions you've added are formed. So I'm somewhat
> undecided...

The qown vs id distinction bothers me a little bit.

I almost want to name it struct kid, and the functions make_kid,
from_kid etc.  Where the emphasis is that we are transforming in and out
of the kernel internal form.  I don't really like make_kid because id as
a base name seems to generic and it barely tells you it is.  Perhaps
make_kqid.  Where we call the quota ids and qid for short?

I am a little uncomfortable calling them kqids because the userspace
code also places format_ids in a plain qid_t.  But make_kqid and
from_kqid seems the best alternate set of names I can come up with.

Eric
