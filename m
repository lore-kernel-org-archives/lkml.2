Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933265Ab1CWQMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:12:01 -0400
Received: from smtp104.prem.mail.sp1.yahoo.com ([98.136.44.59]:44787 "HELO
	smtp104.prem.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933172Ab1CWQL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:11:58 -0400
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-YMail-OSG: gzCLqN8VM1l.Vmt8BI2YMeZIu9tM06C4EtKG3E.zbr6.z4v
 2v6ga_LBum3Yrh.AGRdaayLl1uw3ATOcRGZefM2obFb3mRZac0c92c0Vw6A_
 .SFC17sclcV74O1VtgkwBp8QXMaUQeSxGVW2TSE6sde1tTMFNpE_Eajk5ini
 S1y3SBTDJik8C2MflkUYvAqpAFwJB5hJsf0SiK5oVsogbQPODYq.Quks1LQX
 iyFky8MMsvb_GPMExJH26l5oBFwCAa_ixwHmTx0ynWWDIuBrNKfxTcG4HYDS
 5rVzr1m92kH8NsOICPFI0rlGGqhoF65.ml4g-
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4D8A1BB4.4030709@schaufler-ca.com>
Date: Wed, 23 Mar 2011 09:11:32 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: David Miller <davem@davemloft.net>, pekane52@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        cxzhang@watson.ibm.com, sds@tycho.nsa.gov, jmorris@namei.org,
        eparis@parisplace.org, paul.moore@hp.com,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2] net/unix: Add secdata to unix_stream msgs
References: <1300840717-4413-1-git-send-email-pekane52@gmail.com>	 <20110322.193206.28821045.davem@davemloft.net> <1300895847.28871.13.camel@unknown001a4b0c2895>
In-Reply-To: <1300895847.28871.13.camel@unknown001a4b0c2895>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/2011 8:57 AM, Eric Paris wrote:
> On Tue, 2011-03-22 at 19:32 -0700, David Miller wrote:
>> From: Pat Kane <pekane52@gmail.com>
>> Date: Tue, 22 Mar 2011 19:38:37 -0500
>>
>>> The unix_dgram routines add secdata to socket messages,
>>> but the unix_stream routines do not. I have added the
>>> two missing lines of code.
>>>
>>> Signed-off-by: Pat Kane <pekane52@gmail.com>
>> The security hooks appear to be only intended to operate on datagram
>> sockets, and as such I think the omission of UNIX stream sockets was
>> very much on purpose.
>>
>> The SELINUX hook implementations even have "_dgram()" in their names.
>>
>> Catherine Zhang added to CC: as she last made modifications to these
>> hooks.
> And I'll add Paul Moore as I think he understands the intersection
> of /net and /security better than anyone.

Paul is definitely the man on this. I've also added the LSM list,
as while SELinux is the only current user of secdata that may not
always be the case.


>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>> index 1663e1a..8753cdd 100644
>>> --- a/net/unix/af_unix.c
>>> +++ b/net/unix/af_unix.c
>>> @@ -1642,6 +1642,8 @@ static int unix_stream_sendmsg(struct kiocb *kiocb, struct socket *sock,
>>>  		max_level = err + 1;
>>>  		fds_sent = true;
>>>  
>>> +		unix_get_secdata(siocb->scm, skb);
>>> +
>>>  		err = memcpy_fromiovec(skb_put(skb, size), msg->msg_iov, size);
>>>  		if (err) {
>>>  			kfree_skb(skb);
>>> @@ -1930,6 +1932,7 @@ static int unix_stream_recvmsg(struct kiocb *iocb, struct socket *sock,
>>>  		} else {
>>>  			/* Copy credentials */
>>>  			scm_set_cred(siocb->scm, UNIXCB(skb).pid, UNIXCB(skb).cred);
>>> +			unix_set_secdata(siocb->scm, skb);
>>>  			check_creds = 1;
>>>  		}
>>>  
>>> -- 
>>> 1.7.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>

