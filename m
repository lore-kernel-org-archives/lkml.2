Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab2H0Pyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 11:54:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:34932 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab2H0Pyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 11:54:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>,
        David Miller <davem@davemloft.net>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, Ben Myers <bpm@sgi.com>,
        Alex Elder <elder@kernel.org>, xfs@oss.sgi.com,
        Dmitry Monakhov <dmonakhov@openvz.org>
References: <87lih2h6i4.fsf@xmission.com> <87harqecvk.fsf@xmission.com>
	<20120827085034.GA8998@quack.suse.cz>
Date: Mon, 27 Aug 2012 08:54:21 -0700
In-Reply-To: <20120827085034.GA8998@quack.suse.cz> (Jan Kara's message of
	"Mon, 27 Aug 2012 10:50:34 +0200")
Message-ID: <87haro8h5e.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+PpHkkNssbMWStGKBjAIZrnUY48wuSZpE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1150]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jan Kara <jack@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 13/15] userns: Add basic quota support
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hello,
>
> On Sat 25-08-12 17:05:35, Eric W. Biederman wrote:
>> Two helper are added dqgetusr and dqgetgrp to allow the quota
>> infrastructure to be called with a kuid and a kgid respectively.  This
>> creates type safe variants of dqget and leads to shorter more
>> comprehensible code.
>   It would look more comprehensible to me to have functions like:
> kuid2qown() and kgid2qown() and then call dqget(sb, kuid2qown(attr->uid))
> (see below for qown_t change proposal). The code then at the first look
> explains what is going on... Hmm?
>
>> Place the USRQUOTA and GRPQUOTA defines into enum quota_type.  This
>> brings with it the ability for the compiler to check that switch
>> statements handle every quota type, and the ability to mark which
>> values store the type of a quota entry.
>   OK, makes sense.
>
>> Add the data type qown_t a union of kuid_t and kgid_t. qown_t is a
>> replacement for the implicit union of uid and gid stored in an
>> unsigned int that is was used in the quota data structures.  Making
>> the data type explicit allows the kuid_t and kgid_t type safety to
>> propogate more thoroughly through the code, revealing more places
>> where uid/gid conversions need be made.
>   Hum, when we already do this, wouldn't it make more sense to embed quota
> type in qown_t? Because with the union thing you have no meaningful way of
> accessing that type without having quota type anyway. So having that in a
> single structure makes a lot of sense, plus it makes prototypes shorter...
> And you have to call make_qown() anyway...

So I think there was a reason for having the type separate but I'm not
seeing that reason off the top of my head.

I think it was filesystems like gfs2 doing weird things.  But I tell
you want I will play with this and if I can't reproduce find a reason
for putting them in one structure I will because there are definitely
good reasons for doing that.


>> Allong with the data type qown_t comes the helper functions
>> qown_eq, from_qown, from_qown_munged, qown_valid, and make_qown.
>> 
>> Update struct dquot dq_id to be a qown_t.
>> 
>> Update the signature of dqget, quota_send_warning, dquot_get_dqblk,
>> and dquot_set_dqblk to use enum quota_type and qown_t.
>> 
>> Make minimal changes to gfs2, ocfs2, and xfs to deal with the change
>> in quota structures and signatures.  The ocfs2 changes are larger than
>> most because of the extensive tracing throughout the ocfs2 quota code
>> that prints out dq_id.
>   Otherwise the changes look OK to me, although I didn't check them in
> detail yet (as above suggestions will change the code anyway).
>
> 								Honza

Thanks, 

Eric
