Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab2CGPdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 10:33:47 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932254Ab2CGPdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 10:33:46 -0500
Message-ID: <4F577FD5.9080601@nod.at>
Date: Wed, 07 Mar 2012 16:33:41 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: jengelh@medozas.de, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [PATCH 6/6] Netfilter: xt_LOG: Add timestamp support
References: <1330989588-26833-1-git-send-email-richard@nod.at> <1330989588-26833-7-git-send-email-richard@nod.at> <20120307152910.GA7044@1984>
In-Reply-To: <20120307152910.GA7044@1984>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.03.2012 16:29, Pablo Neira Ayuso wrote:
> On Tue, Mar 06, 2012 at 12:19:48AM +0100, Richard Weinberger wrote:
>> Using XT_LOG_ADD_TIMESTAMP it is possible to have a timestamp
>> directly in the log message.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>>   include/linux/netfilter/xt_LOG.h |    3 ++-
>>   net/netfilter/xt_LOG.c           |    8 ++++++++
>>   2 files changed, 10 insertions(+), 1 deletions(-)
>>
>> diff --git a/include/linux/netfilter/xt_LOG.h b/include/linux/netfilter/xt_LOG.h
>> index 8ac25e0..9361374 100644
>> --- a/include/linux/netfilter/xt_LOG.h
>> +++ b/include/linux/netfilter/xt_LOG.h
>> @@ -8,7 +8,8 @@
>>   #define XT_LOG_UID		0x08	/* Log UID owning local socket */
>>   #define XT_LOG_NFLOG		0x10	/* Unsupported, don't reuse */
>>   #define XT_LOG_MACDECODE	0x20	/* Decode MAC header */
>> -#define XT_LOG_MASK		0x2f
>> +#define XT_LOG_ADD_TIMESTAMP	0x40    /* Add a timestamp */
>> +#define XT_LOG_MASK		0x6f
>>
>>   struct xt_log_info {
>>           unsigned char level;
>> diff --git a/net/netfilter/xt_LOG.c b/net/netfilter/xt_LOG.c
>> index f75f2d7..23db206 100644
>> --- a/net/netfilter/xt_LOG.c
>> +++ b/net/netfilter/xt_LOG.c
>> @@ -499,6 +499,14 @@ log_packet_common(struct sbuff *m,
>>   	if (loginfo->type == NF_LOG_TYPE_LOG)
>>   		sb_add(m, "<%d>", loginfo->u.log.level);
>>
>> +	if (loginfo->u.log.logflags&  XT_LOG_ADD_TIMESTAMP) {
>> +		struct timespec tv;
>> +
>> +		getnstimeofday(&tv);
>> +		sb_add(m, "TIMESTAMP=%li.%03u ", tv.tv_sec,
>> +			(unsigned int)tv.tv_nsec / NSEC_PER_MSEC);
>
> net/netfilter/xt_LOG.c: In function ‘log_packet_common’:
> net/netfilter/xt_LOG.c:507:4: warning: format ‘%u’ expects argument of
> type ‘unsigned int’, but argument 4 has type ‘long int’ [-Wformat]
>
> It has to be:
>
>                  sb_add(m, "TIMESTAMP=%li.%03u ", tv.tv_sec,
>                          (unsigned int)(tv.tv_nsec / NSEC_PER_MSEC));
>                                        ^                          ^
> I've fixed, no need to resend this patch.

Which gcc version are you using?
I've not seen this warning. :(

Thanks,
//richard
