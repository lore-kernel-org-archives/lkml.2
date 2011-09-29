Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851Ab1I2PK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 11:10:27 -0400
Received: from fnarfbargle.com ([93.93.131.224]:42093 "EHLO fnarfbargle.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756788Ab1I2PKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 11:10:25 -0400
Message-ID: <4E848A5A.5010200@fnarfbargle.com>
Date: Thu, 29 Sep 2011 23:10:18 +0800
From: Brad Campbell <brad@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: Radeon regression fix
References: <4E847ED4.5090703@fnarfbargle.com> <CADnq5_PUcDVL+RPZPDGiAxHjn=vL7dnNsiQYG2F5e6GWnoX7Kg@mail.gmail.com>
In-Reply-To: <CADnq5_PUcDVL+RPZPDGiAxHjn=vL7dnNsiQYG2F5e6GWnoX7Kg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/09/11 22:36, Alex Deucher wrote:
> On Thu, Sep 29, 2011 at 10:21 AM, Brad Campbell<brad@fnarfbargle.com>  wrote:
>> This patch fixes a regression introduced between 2.6.39&  3.1-rc1 whereby
>> the displayport AUX channel stopped re-trying commands that elicited a DEFER
>> response.
>>
> It should still be retrying, just restructured slightly.  The retry
> logic just moved into radeon_dp_i2c_aux_ch(),
> radeon_dp_aux_native_write(), and radeon_dp_aux_native_read(), e.g.,
>
> 		else if ((ack&  AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
> 			udelay(400);
One problem with that logic I'm afraid.

                 if (ret == 0)
                         return -EPROTO;
                 if (ret < 0)
                         return ret;
                 if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_ACK)
                         return ret;
                 else if ((ack & AUX_NATIVE_REPLY_MASK) == AUX_NATIVE_REPLY_DEFER)
                         udelay(400);
                 else
                         return -EIO;
         }

ret == 0 with a defer as there is no data in the packet. It never even gets past the first hurdle.


