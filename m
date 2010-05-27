Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab0E0GKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 02:10:05 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:18663 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836Ab0E0GKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 02:10:02 -0400
Message-ID: <4BFE0BA5.70809@chelsio.com>
Date: Thu, 27 May 2010 11:35:25 +0530
From: Rakesh Ranjan <rranjan@chelsio.com>
Organization: Chelsio Communications
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mike Christie <michaelc@cs.wisc.edu>
CC: open-iscsi@googlegroups.com, Rakesh Ranjan <rakesh@chelsio.com>,
       NETDEVML <netdev@vger.kernel.org>,
       SCSIDEVML <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Karen Xie <kxie@chelsio.com>,
       David Miller <davem@davemloft.net>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Anish Bhatt <anish@chelsio.com>
Subject: Re: [PATCH 3/3] cxgb4i_v3: iscsi and libcxgbi library for handling
 common part
References: <1273944249-311-1-git-send-email-rakesh@chelsio.com> <1273944249-311-2-git-send-email-rakesh@chelsio.com> <1273944249-311-3-git-send-email-rakesh@chelsio.com> <1273944249-311-4-git-send-email-rakesh@chelsio.com> <4BFE0A3E.9020804@cs.wisc.edu>
In-Reply-To: <4BFE0A3E.9020804@cs.wisc.edu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2010 06:08:57.0609 (UTC) FILETIME=[17C88F90:01CAFD63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 05/27/2010 11:29 AM, Mike Christie wrote:
> On 05/15/2010 12:24 PM, Rakesh Ranjan wrote:
>> From: Rakesh Ranjan<rranjan@chelsio.com>
>>
>>
>> Signed-off-by: Rakesh Ranjan<rakesh@chelsio.com>
>> ---
>>   drivers/scsi/cxgb4i/cxgb4i_iscsi.c |  617
>> ++++++++++++++++++++++++++++++++++++
>>   drivers/scsi/cxgb4i/libcxgbi.c     |  589
>> ++++++++++++++++++++++++++++++++++
>>   drivers/scsi/cxgb4i/libcxgbi.h     |  430 +++++++++++++++++++++++++
> 
> I think the patch had some whitespace/newline issues. When I did git-am
> I got:
> 
> warning: squelched 1 whitespace error
> warning: 6 lines add whitespace errors.
> 
> I think James can just fix up when he merges with git, but in the future
> you might want to try a git-am on your patch before you send (git-am
> --whitespace=fix will fix it up for you).
> 
> 
> 
>> +
>> +int cxgbi_pdu_init(struct cxgbi_device *cdev)
>> +{
>> +    if (cdev->skb_tx_headroom>  (512 * MAX_SKB_FRAGS))
>> +        cdev->skb_extra_headroom = cdev->skb_tx_headroom;
>> +    cdev->pad_page = alloc_page(GFP_KERNEL);
>> +    if (cdev->pad_page)
>> +        return -ENOMEM;
>> +    memset(page_address(cdev->pad_page), 0, PAGE_SIZE);
>> +    return 0;
>> +
>> +    /*
>> +    if (SKB_TX_HEADROOM>  (512 * MAX_SKB_FRAGS))
>> +        skb_extra_headroom = SKB_TX_HEADROOM;
>> +    pad_page = alloc_page(GFP_KERNEL);
>> +    if (!pad_page)
>> +        return -ENOMEM;
>> +    memset(page_address(pad_page), 0, PAGE_SIZE);
>> +    return 0;*/
> 
> Clean this up.
> 
>> +
>> +void cxgbi_release_itt(struct iscsi_task *task, itt_t hdr_itt)
>> +{
>> +    struct scsi_cmnd *sc = task->sc;
>> +    struct iscsi_tcp_conn *tcp_conn = task->conn->dd_data;
>> +    struct cxgbi_conn *cconn = tcp_conn->dd_data;
>> +    struct cxgbi_device *cdev = cconn->chba->cdev;
>> +    struct cxgbi_tag_format *tformat =&cdev->tag_format;
>> +    u32 tag = ntohl((__force u32)hdr_itt);
>> +
>> +    cxgbi_tag_debug("release tag 0x%x.\n", tag);
>> +
>> +    if (sc&&
>> +        (scsi_bidi_cmnd(sc) ||
>> +         sc->sc_data_direction == DMA_FROM_DEVICE)&&
>> +            cxgbi_is_ddp_tag(tformat, tag))
> 
> The formatting is a little weird. I think you want each line to start in
> the same column instead of each getting tabbed over.
> 
> 
>> +
>> +
>> +int cxgbi_reserve_itt(struct iscsi_task *task, itt_t *hdr_itt)
>> +{
>> +    struct scsi_cmnd *sc = task->sc;
>> +    struct iscsi_conn *conn = task->conn;
>> +    struct iscsi_session *sess = conn->session;
>> +    struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
>> +    struct cxgbi_conn *cconn = tcp_conn->dd_data;
>> +    struct cxgbi_device *cdev = cconn->chba->cdev;
>> +    struct cxgbi_tag_format *tformat =&cdev->tag_format;
>> +    u32 sw_tag = (sess->age<<  cconn->task_idx_bits) | task->itt;
>> +    u32 tag;
>> +    int err = -EINVAL;
>> +
>> +    if (sc&&
>> +        (scsi_bidi_cmnd(sc) ||
>> +         sc->sc_data_direction == DMA_FROM_DEVICE)&&
>> +            cxgbi_sw_tag_usable(tformat, sw_tag)) {
> 
> 
> Same tabbing.
> 
> 
>> +    volatile unsigned int state;
> 
> I did not get why this needed to be volatile (I see it is like this in
> cxgb3i and I did not see why in there too).
> 
> 
> 
>> +
>> +static inline void cxgbi_sock_hold(struct cxgbi_sock *csk)
>> +{
>> +    atomic_inc(&csk->refcnt);
> 
> 
> We want people to use krefs instead of their own refcounting now.
> 
>> +
>> +static inline void *cplhdr(struct sk_buff *skb)
>> +{
>> +    return skb->data;
>> +}
> 
> 
> Seems kinda useless.

Hi Mike,

Thanks for the review, will send you the updated patch.

Regards
Rakesh Ranjan

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJL/guKAAoJEBqoHbxtDU4JFvQP/2uIWFmZo4nqcJ7xmEiBjnaq
BeUfjbRGaiAImEM/6OuMIB/Fm9p9NGtW0GsZdqKYSdZBmgO1kWNT1onCZgVF4eW1
Muikjo+I2wXGsWIt4ZqbZs722COC1oQHXpyulfh/6ONzeWJ3R8vos/TnCw256Wxj
HL42jIO882JCImzmP/wmdPmDlTUI/Z0UEYbu0djy20yzESo2NDHq1PYYopyXIboH
joJ/sZvK0jRYrRsDdq84XJ8CUv1yDE8m3NiMV8cV9JN1EwP/gzBrq0DXfFgpdEDU
+4/pfzzxJ5y/ekdZaSZdx9ke/n/vmamJCaQONaL2WfQaznogxqZypaoM/NRzfMlH
40KY5lqajGRnm0aEBffn8uqBzEbopYpb1m+3mzt/vDtvdBRuSJqmcPbUandTNHLe
cZQnn689GtWqJfoyVF/dfyubtAZFLu8VVZkFxx1e3UDEqVDUuwVEHXoXSt6K/SkB
UnZI7hMUYSof+WI+UEV8DR4KMsRbE1cnvXGnsXTZOMhMsU3KoMielaGTgepAbxT7
bLfaARiMwvU+vle5546uK8IuxjGH81nbUEy6R86OeS6Osv6PZFiGYP9yxjzkp4K7
NWOTnVV9qTaPPTtN9SORINPXUXuI90JgIDbh9qnfDDKl2oj5HmwBpa7S3KmMxxlI
eoAqa/9LLjrMVi5Wicv3
=TOBq
-----END PGP SIGNATURE-----
