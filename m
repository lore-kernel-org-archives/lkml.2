Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab0JNVei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:34:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62409 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab0JNVeh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:34:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mckjnKnr8LYK30bPMG9kQL32umiSp5fbs1rMiePdN8oQxfDtEm3pWABNLeHBhJjgBm
         I4obnTNg/KGSp9ziHcH/vk2V84zhCCr8tcsxB6Tp6hzmRIcYSPtbouEAKKILkM5BwDXU
         NbAFhdT2pM0JtYDlkfS6NHL3krQhJlZ/Aw3ts=
MIME-Version: 1.0
In-Reply-To: <4CB56E7F.3030908@cn.fujitsu.com>
References: <AANLkTimEQkDpWorCF4HUq6N-xAnFz4xE89osAtcJY_Mn@mail.gmail.com>
	<4CB56E7F.3030908@cn.fujitsu.com>
Date: Thu, 14 Oct 2010 13:41:25 -0400
X-Google-Sender-Auth: IgNN3s9j5EugV8WIMwws36LaSRA
Message-ID: <AANLkTim2XA1i+AbqV95u_4FWLViVuNXqJxEnaMqm-3yF@mail.gmail.com>
Subject: Re: [PATCHv2 3/5] sctp: extend socket API for sched configuration
From: Yaogong Wang <ywang15@ncsu.edu>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: linux-sctp@vger.kernel.org, Vlad Yasevich <vladislav.yasevich@hp.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reason is that SCTP supports one-to-many style socket where one
socket handles multiple associations (and hence multiple outqueues).
In that case, if we only store scheduling configurations in the
socket, it may cause several problems:
1. All associations handled by this socket must share the same
scheduling policy.
2. If you change the scheduling algorithm of the socket when some
associations are already established, we have to change the scheduling
of on-going associations, which may be complicated and error-prone.

If we only store scheduling configurations in the association, the
difficulty is: when should the application set these configurations?
In one-to-many style socket, associations are implicitly established.
There isn't a point where association is established but data transfer
hasn't started yet so that the user can configure the scheduling
algorithm. We again has to deal with the problem of changing
scheduling when data transfer is under way.

The current design is a compromise of the two approaches. Scheduling
configurations are set at the socket level and stored in sctp_sock.
When a new association is established, it inherits the scheduling
configurations from the socket. If the application changes the
scheduling configurations of the socket on the fly, only associations
established after the change are affected. That way, we are able to
have different scheduling algorithms for associations handled by one
socket and we eliminate the trouble to change scheduling policy on the
fly.

Thanks,
Yaogong

On Wed, Oct 13, 2010 at 4:31 AM, Shan Wei <shanwei@cn.fujitsu.com> wrote:
> Yaogong Wang wrote, at 09/12/2010 09:13 AM:
>> Augment SCTP socket API with a new socket option SCTP_SCHED
>> to choose and configure multistream scheduling algorithm.
>>
>> Signed-off-by: Yaogong Wang <ywang15@ncsu.edu>
>> ---
>>  include/net/sctp/structs.h |    4 ++
>>  include/net/sctp/user.h    |   19 ++++++++++
>>  net/sctp/outqueue.c        |    4 ++
>>  net/sctp/sm_sideeffect.c   |   45 +++++++++++++++++++++++--
>>  net/sctp/socket.c          |   80 ++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 149 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
>> index 52af764..1a76417 100644
>> --- a/include/net/sctp/structs.h
>> +++ b/include/net/sctp/structs.h
>> @@ -333,6 +333,8 @@ struct sctp_sock {
>>
>>       /* Multistream scheduling */
>>       const struct sctp_sched_ops *sched_ops;
>> +     __u16 sched_config_len;
>> +     void *sched_config;
>>
>>       struct sctp_initmsg initmsg;
>>       struct sctp_rtoinfo rtoinfo;
>> @@ -1173,6 +1175,8 @@ struct sctp_outq {
>>
>>       /* Multistream scheduling */
>>       const struct sctp_sched_ops *sched_ops;
>> +     __u16 sched_config_len;
>> +     void *sched_config;
>
> Why did you take these two fields into sctp_sock and sctp_outq?
> These two fields between sctp_sock and sctp_outq has same role,
> we can only defined in one place.
> How about using sctp_sk(sctp_outq->asoc->base.sk) to access these two
> fields?
>
>
> --
> Best Regards
> -----
> Shan Wei
>



-- 
========================
Yaogong Wang, PhD candidate
Department of Computer Science
North Carolina State University
http://www4.ncsu.edu/~ywang15/
========================
