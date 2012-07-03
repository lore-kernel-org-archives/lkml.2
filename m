Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2GCLr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 07:47:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab2GCLr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 07:47:58 -0400
Message-ID: <4FF2DBD3.4080800@redhat.com>
Date: Tue, 03 Jul 2012 13:47:31 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, snitzer@redhat.com,
        martin.petersen@oracle.com, david@fromorbit.com, xfs@oss.sgi.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v2 2/3] block: reorganize rounding of max_discard_sectors
References: <1341235225-27551-1-git-send-email-pbonzini@redhat.com> <1341235225-27551-3-git-send-email-pbonzini@redhat.com> <20120703024910.GC3586@redhat.com>
In-Reply-To: <20120703024910.GC3586@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/07/2012 04:49, Vivek Goyal ha scritto:
>> > +	/* Zero-sector (unknown) and one-sector granularities are the same.  */
>> > +	granularity = max(q->limits.discard_granularity >> 9, 1U);
>> > +
>> >  	/*
>> >  	 * Ensure that max_discard_sectors is of the proper
>> >  	 * granularity
>> >  	 */
>> >  	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
>> > +	max_discard_sectors = round_down(max_discard_sectors, granularity);
>> >  	if (unlikely(!max_discard_sectors)) {
>> >  		/* Avoid infinite loop below. Being cautious never hurts. */
>> >  		return -EOPNOTSUPP;
>> > -	} else if (q->limits.discard_granularity) {
>> > -		unsigned int disc_sects = q->limits.discard_granularity >> 9;
>> > -
>> > -		max_discard_sectors &= ~(disc_sects - 1);
> This is kind of odd. If discard_granularity is zero, we assume that
> discards are supported and granularity is 1. But if max_discard_sectors
> is zero, we assume discards are disabled. Not sure if we should treat
> max_discard_sectors and discard_granularity in same way or not.

Yes, this keeps the same behavior as before.  It is also the one that is
consistent with drivers/scsi/sd.c.  sd_config_discard always sets
limits.discard_granularity and then uses limits.max_discard_sectors to
disable discards.

Paolo
