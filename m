Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752431Ab2GEMGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:06:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910Ab2GEMGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:06:41 -0400
Message-ID: <4FF58320.1050606@redhat.com>
Date: Thu, 05 Jul 2012 14:05:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH v2 2/2] ata: implement MODE SELECT command
References: <1341481235-12708-1-git-send-email-pbonzini@redhat.com> <1341481235-12708-3-git-send-email-pbonzini@redhat.com> <4FF57DAA.8010405@mvista.com>
In-Reply-To: <4FF57DAA.8010405@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 05/07/2012 13:42, Sergei Shtylyov ha scritto:
>> +    six_byte = (cdb[0] == MODE_SELECT);
>> +    if (six_byte) {
>> +        if (scmd->cmd_len < 5)
>> +            goto invalid_fld;
> 
>    Strictly speaking, it should be "invalid phase" error.
> 
>> +
>> +        len = cdb[4];
>> +    } else {
>> +        if (scmd->cmd_len < 9)
>> +            goto invalid_fld;
> 
>    The same.
> 
>> +
>> +        len = (cdb[7] << 8) + cdb[8];
>> +    }
>> +    /* Test early for possible overrun.  */
>> +    if (!scsi_sg_count(scmd) || scsi_sglist(scmd)->length < len)
>> +        goto invalid_param_len;
> 
>     Strictly speaking, it's "data underrun" error.

The exact errors don't really matter, they shouldn't happen at all.  But
they're important so that we don't access uninitialized memory in case
they do.  Existing xlat functions are similarly hand-wavy.

>> +    p = page_address(sg_page(scsi_sglist(scmd)));
> 
>    What if the S/G list spans multiple non-consecutive pages?

Hmm, with a large number of block descriptors we could indeed span more
than one page.  On the other hand, we can just fail with invalid_param
if there is more than one block descriptor, so we're guaranteed not to
look beyond the first page (4 bytes for the header, 8 bytes for the
block descriptor, 4 bytes for the mode page header, 10 bytes for the
mode page).

>> +
>> +    /* Move past header and block descriptors.  */
>> +    if (six_byte)
>> +        hdr_len = p[3] + 4;
>> +    else
>> +        hdr_len = (p[6] << 8) + p[7] + 8;
>> +
>> +    if (len < hdr_len)
>> +        goto invalid_param_len;
>> +
>> +    len -= hdr_len;
>> +    p += hdr_len;
>> +    if (len == 0)
>> +        goto skip;
>> +
>> +    /* Parse both possible formats for the mode page headers.  */
>> +    pg = p[0] & 0x3f;
>> +    if (p[0] & 0x40) {
>> +        if (len < 4)
>> +            goto invalid_param_len;
>> +
>> +        spg = p[1];
>> +        pg_len = (p[2] << 8) | p[3];
>> +        p += 4;
>> +        len -= 4;
>> +    } else {
>> +        if (len < 2)
>> +            goto invalid_param_len;
>> +
>> +        spg = 0;
>> +        pg_len = p[1];
>> +        p += 2;
>> +        len -= 2;
>> +    }
>> +
>> +    /*
>> +     * Only one page has changeable data, so we only support setting one
>> +     * page at a time.
>> +     */
>> +    if (len < pg_len)
>> +        goto invalid_param;
> 
>     Not 'invalid_param_len'?

No (it is more like a shortcut for the "default" case of the switch
statement below), but it should be "if (len > pg_len)" rather than <.
It's also clearer to move it closer to the end of the function.

>> +
>> +    /*
>> +     * No mode subpages supported (yet) but asking for _all_
>> +     * subpages may be valid
>> +     */
>> +    if (spg && (spg != ALL_SUB_MPAGES))
>> +        goto invalid_param;
> 
>    Rather "paramater not supported" (0x26/0x01)...

SCSI spec begs to differ... there is no reference to that sense code in
the whole SPC spec.

>> +    if (pg_len > len)
>> +        goto invalid_param_len;
> 
>    We have just checked this.

See above.

>> +    switch (pg) {
>> +    case CACHE_MPAGE:
>> +        if (ata_mselect_caching(qc, p, pg_len) < 0)
>> +            goto invalid_param;
> 
>    Rather "parameter not supported"?

Same here, SCSI spec says "invalid field in parameter list", I obey.

>> +        break;
>> +
>> +    default:        /* invalid page code */
>> +        goto invalid_param;
> 
>    Rather "paramater not supported"...

Same here too.

Thanks for the review.

Paolo

>> +    }
>> +
>> +    return 0;
> 
> MBR, Sergei


