Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab1DTXuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:50:18 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:26592 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752408Ab1DTXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:50:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Apr 2011 19:50:16 EDT
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: qJwru3kVM1mWc4UgemnoQgZ8jNqcF6hhZL13PTyUfvMNBhl
 .mwx.HNgX3G7s1IuzS7dq18n9eGTJ8zfThdtNDIdJl5Eo1k3Y7qEVBLfTjGf
 oztzCOq0nbkQ.Gm6hQNxV0iFV7gykua6DlIyqEq6kLfu0Ud8wk80Qbqujzu7
 mCzk_RgjIkFtO4ymJDxoXh9qsOYckkaq4CqKVDfalBkVQmvebkarTiSBiFM2
 aZZHii3wfEd2O7Qob8LICaW0ZjV8iVxsFg0qPfQKVkA.ntaaqArcLW4Q2AoJ
 3RjfYRy3D9BGsBX7PED2DGW2HEGmLg9fj8x4FBzlhLPSOzXbtMA6ehO2k9Yg
 BVbz_rtVc6l_VAYYfuSQjpw6H957m6fbAbygVE.RD4Os-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4DAF6FA5.7080801@schaufler-ca.com>
Date: Wed, 20 Apr 2011 16:43:33 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, jmorris@namei.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] SMACK: Add missing rcu_read_lock/unlock for process capability
 walk.
References: <1303336844-31074-1-git-send-email-andi@firstfloor.org> <4DAF637D.90606@schaufler-ca.com> <20110420231859.GB32402@tassilo.jf.intel.com>
In-Reply-To: <20110420231859.GB32402@tassilo.jf.intel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/2011 4:18 PM, Andi Kleen wrote:
> On Wed, Apr 20, 2011 at 03:51:41PM -0700, Casey Schaufler wrote:
>> On 4/20/2011 3:00 PM, Andi Kleen wrote:
>>> From: Andi Kleen <ak@linux.intel.com>
>>>
>>> smk_access_entry does a RCU list walk for a list shared with other
>>> threads. It relies on the caller doing rcu_read_lock().
>>> One caller forgot to do to this, which could lead to races
>>> on preemptible kernels.
>>>
>>> Move the rcu_read_lock() into smk_access_entry instead.
>> Nacked-by: Casey Schaufler <casey@schaufler-ca.com>
>>
>> The lock was moved out of smk_access_entry in support of the
>> processing done in the smack_mmap_file() hook. Where do you see
>> a potential race, and which caller "forgot" to do the lock?
> There are two callers and only one takes it.

There are two callers in smack_access.c.
There are four more in smack_lsm.c

> The one that doesn't take it is smk_curacc.

The call in smk_curacc() is using the task local list, not the system list.

> I checked the callers of that and there is no rcu_read_lock() in those
>
> As far as I understand the cred which holds this list is shared
> between threads and other threads can modify it. Which means 
> it needs RCU read lock protection.

The global list, yes. The task specific list, no. Modifying the local
list is like any other modification of the cred structure and requires
the cred be copied.

Moving the lock into smk_access_entry() would introduce a potential
deadlock in smack_mmap_file. There is a bit of convolution in the
mmap hook that requires looking at the list in a way that does not
allow the locking to be embedded where it used to be.

> -Andi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

