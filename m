Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab1G0TXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 15:23:48 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:37349 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1G0TXp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 15:23:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>, dan@aloni.org, davem@davemloft.net,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com, stable@vger.kernel.org
References: <20110726534.972201586@firstfloor.org>
	<20110727003518.6DA772403FF@tassilo.jf.intel.com>
	<4E3035BE.6090908@canonical.com>
Date: Wed, 27 Jul 2011 12:23:35 -0700
In-Reply-To: <4E3035BE.6090908@canonical.com> (Tim Gardner's message of "Wed,
	27 Jul 2011 09:58:54 -0600")
Message-ID: <m1sjprfryg.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19lzFDp+90WMGVVm2gUszyStGy2kAwUnHo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 T_FRT_STOCK2 BODY: ReplaceTags: Stock (2)
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tim Gardner <tim.gardner@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [stable] [PATCH] [26/98] af_unix: Only allow recv on connected seqpacket sockets.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Gardner <tim.gardner@canonical.com> writes:

> On 07/26/2011 06:35 PM, Andi Kleen wrote:
>> 2.6.35-longterm review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>> From: Eric W. Biederman<ebiederm@xmission.com>
>>
>> commit a05d2ad1c1f391c7f514a1d1e09b5417968a7d07 upstream.
>>
>> This fixes the following oops discovered by Dan Aloni:
>>> Anyway, the following is the output of the Oops that I got on the
>>> Ubuntu kernel on which I first detected the problem
>>> (2.6.37-12-generic). The Oops that followed will be more useful, I
>>> guess.
>>
>>> [ 5594.669852] BUG: unable to handle kernel NULL pointer dereference
>>> at Â  Â  Â  Â  Â  (null)
>>> [ 5594.681606] IP: [<ffffffff81550b7b>] unix_dgram_recvmsg+0x1fb/0x420
>>> [ 5594.687576] PGD 2a05d067 PUD 2b951067 PMD 0
>>> [ 5594.693720] Oops: 0002 [#1] SMP
>>> [ 5594.699888] last sysfs file:
>>
>> The bug was that unix domain sockets use a pseduo packet for
>> connecting and accept uses that psudo packet to get the socket.
>> In the buggy seqpacket case we were allowing unconnected
>> sockets to call recvmsg and try to receive the pseudo packet.
>>
>> That is always wrong and as of commit 7361c36c5 the pseudo
>> packet had become enough different from a normal packet
>> that the kernel started oopsing.
>>
>> Do for seqpacket_recv what was done for seqpacket_send in 2.5
>> and only allow it on connected seqpacket sockets.
>>
>> Tested-by: Dan Aloni<dan@aloni.org>
>> Signed-off-by: Eric W. Biederman<ebiederm@xmission.com>
>> Signed-off-by: David S. Miller<davem@davemloft.net>
>> Signed-off-by: Greg Kroah-Hartman<gregkh@suse.de>
>> Signed-off-by: Andi Kleen<ak@linux.intel.com>
>>
>> ---
>>   net/unix/af_unix.c |   16 +++++++++++++++-
>>   1 file changed, 15 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6.35.y/net/unix/af_unix.c
>> ===================================================================
>> --- linux-2.6.35.y.orig/net/unix/af_unix.c
>> +++ linux-2.6.35.y/net/unix/af_unix.c
>> @@ -504,6 +504,8 @@ static int unix_dgram_connect(struct soc
>>   			      int, int);
>>   static int unix_seqpacket_sendmsg(struct kiocb *, struct socket *,
>>   				  struct msghdr *, size_t);
>> +static int unix_seqpacket_recvmsg(struct kiocb *, struct socket *,
>> +				  struct msghdr *, size_t, int);
>>
>>   static const struct proto_ops unix_stream_ops = {
>>   	.family =	PF_UNIX,
>> @@ -563,7 +565,7 @@ static const struct proto_ops unix_seqpa
>>   	.setsockopt =	sock_no_setsockopt,
>>   	.getsockopt =	sock_no_getsockopt,
>>   	.sendmsg =	unix_seqpacket_sendmsg,
>> -	.recvmsg =	unix_dgram_recvmsg,
>> +	.recvmsg =	unix_seqpacket_recvmsg,
>>   	.mmap =		sock_no_mmap,
>>   	.sendpage =	sock_no_sendpage,
>>   };
>> @@ -1676,6 +1678,18 @@ static int unix_seqpacket_sendmsg(struct
>>   	return unix_dgram_sendmsg(kiocb, sock, msg, len);
>>   }
>>
>> +static int unix_seqpacket_recvmsg(struct kiocb *iocb, struct socket *sock,
>> +			      struct msghdr *msg, size_t size,
>> +			      int flags)
>> +{
>> +	struct sock *sk = sock->sk;
>> +
>> +	if (sk->sk_state != TCP_ESTABLISHED)
>> +		return -ENOTCONN;
>> +
>> +	return unix_dgram_recvmsg(iocb, sock, msg, size, flags);
>> +}
>> +
>>   static void unix_copy_addr(struct msghdr *msg, struct sock *sk)
>>   {
>>   	struct unix_sock *u = unix_sk(sk);
>>
>>
>>
>>
>> _______________________________________________
>> stable mailing list
>> stable@linux.kernel.org
>> http://linux.kernel.org/mailman/listinfo/stable
>
> Andi - Ubuntu has reverted this patch for both Lucid (2.6.32) and Natty (2.6.38)
> as it appears to cause a networking regression, though we never really figured
> out root cause. Empirically, reverting the patch solved the issue. Eric
> Biederman theorized that it uncovered a user space issue (trying to read before
> listen), but the bug reporter seems to have lost interest in testing kernels so
> we couldn't ever pin it down.

No.  This patch is no more likely to have caused your network regression
than any other patch you added to your kernel at that time.  Touching
af_unix.c in a trivial way will not affect tcp/ip networking.

I am insulted that you said this change caused your problem rather than
saying it was simply correlated with your problem.

> http://bugs.launchpad.net/bugs/791512
>
> We also decided that reverting this patch was likely OK because we couldn't find
> any Launchpad reports of the Ooops mentioned in the patch commit log, nor does a
> google search turn up any hits.

That you did not find the original bug report I find as dubious as the
rest of your analysis of this patch.


The only kernels that can oops in the way that was reported are kernels
that have the fix to the make it safe to pass credentials between
processes in different user or pid namespaces.

My patch only affects attempting to send or recv packets on an af_unix
after calling listen, where accept is the only valid operation.  Only
broken application can possibly care about this case.

For 2.6.32 you are not open to the chance of an oops.  So shrug who
cares if you defend against it.

For 2.6.38, and Andi's 2.6.35 which has the potential for an
unprivileged process to trigger an oops, it seems irresponsible to me to
not include this change.  People who exploit kernel flaws seem good at
taking random Oops's and converting them into methods for privilege
escalation.

Tim your argument against the patch feels like an argument that we
should revert this patch from the networking stack in Linus's kernel.
Is that what you were trying to say?

Eric

