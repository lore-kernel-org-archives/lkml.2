Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757Ab1LLSdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:33:15 -0500
Received: from usindpps06.hds.com ([207.126.252.19]:33573 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449Ab1LLSdJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:33:09 -0500
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Don Zickus <dzickus@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>, "Chen, Gong" <gong.chen@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "'ying.huang@intel.com'" <'ying.huang@intel.com'>,
        "'ak@linux.intel.com'" <'ak@linux.intel.com'>,
        "'hughd@chromium.org'" <'hughd@chromium.org'>,
        "'mingo@elte.hu'" <'mingo@elte.hu'>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "namhyung@gmail.com" <namhyung@gmail.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Date: Mon, 12 Dec 2011 13:32:16 -0500
Subject: RE: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Topic: [RFC][PATCH v3 2/3] Skip spin_locks in panic case and add
 WARN_ON()
Thread-Index: Acy45u6rvyeczNRlQ4u2K/evnn5cKQAFPqJQ
Message-ID: <5C4C569E8A4B9B42A84A977CF070A35B2C57EE46F2@USINDEVS01.corp.hds.com>
References: <5C4C569E8A4B9B42A84A977CF070A35B2C57DC0D10@USINDEVS01.corp.hds.com>
 <20111212155827.GR1669@redhat.com>
In-Reply-To: <20111212155827.GR1669@redhat.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ja-JP, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1012030000
 definitions=main-1112120180
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> -	if (in_nmi()) {
>> -		is_locked = spin_trylock(&psinfo->buf_lock);
>> -		if (!is_locked)
>> -			pr_err("pstore dump routine blocked in NMI, may corrupt error record\n");
>> -	} else
>> +	/*
>> +	 * pstore_dump() is serialized in panic path.
>> +	 * So, we don't need to take any locks.
>> +	 */
>> +	if (reason != KMSG_DUMP_PANIC)
>>  		spin_lock_irqsave(&psinfo->buf_lock, flags);
>
>This probably won't work because the original check wasn't necessarily for
>locking purposes but to see if a lock was already taken in the serialized
>path.  If buf_lock is already held, the code may have trouble executing
>the backend, hence the pr_err.

If locking of backend drivers ,such as erst_lock/efivars_lock, was held in serialized path,
the backend drivers may have some troubles.

On the other hand, pstore will not have any trouble with my code because psinfo->buf_lock is protecting 
the memory ,psinfo->buf, which backend driver use to save data and the content of psinfo->buf is
simply overwritten in pstore_dump().

So, pstore can just blindly continue even if psinfo->buf_lock is held in the serialized path.

If there are some troubles in backend drivers, they should be fixed.


I guess you suggest me to add some code checking lock status so that users/developers know 
the reason why pstore failed.
So, I have a comment about that.

If you would like to just check if a lock was already in the serialized path,
"is_spin_locked()" macro is better.
In addition to that, if you would like to let users know the locking status, pr_err() is needed. 
So, the code will be as follows.

 if (reason == KMSG_DUMP_PANIC) {
 	if(is_spin_locked(&psinfo->buf_lock))
 		pr_err("lock is taken.\n");
 else {
 	spin_lock_irqsave(&psinfo->buf_lock, flags);
 }

However, this won't work for this reason.
  - printk() must not be called in serialized path because deadlock of logbuf_lock may cause.
  
Of course, we can avoid deadlock if spin_lock_init(logbuf_lock) is called. But spin_lock_init() 
is not accepted in previous discussion.



>> +	WARN_ON(in_nmi() && reason != KMSG_DUMP_PANIC);
>> +
>
>You will need a comment to explain why the above is there.

I agree. The comment is needed.

Seiji

