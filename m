Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab0LTSnx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:43:53 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:40231 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0LTSnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:43:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hVL4fkjEaWJDRxjUNaGrriQHcDEAjGjgnBNhyBWWGF69v3Hn6Ktuz7KgKvdMNc735W
         4u32Oq+r7DzIirNYRuInwlV4KM9nNapdNcDTkWEAtRKMs/gD+Wn5V2vo74/ac0mL7Bzt
         bVssESfRGhIOQ0JtgipAZQ97hwLL6CcYAM4xQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=C4hvf9t9j51TE3JNdygHbjf-vAQBvdf+Oimfh@mail.gmail.com>
References: <1292865120-24020-1-git-send-email-felipe.contreras@nokia.com>
	<AANLkTi=C4hvf9t9j51TE3JNdygHbjf-vAQBvdf+Oimfh@mail.gmail.com>
Date: Mon, 20 Dec 2010 20:43:50 +0200
Message-ID: <AANLkTi=B2MFz=c9gzcP3ZpApipShYbK88sbFmOOn3QKM@mail.gmail.com>
Subject: Re: [PATCH] staging: tidspbridge: protect dmm_map properly
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Kanigeri, Hari" <h-kanigeri2@ti.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        Nishanth Menon <nm@ti.com>, Ameya Palande <ameya.palande@nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 20, 2010 at 8:30 PM, Kanigeri, Hari <h-kanigeri2@ti.com> wrote:
> On Mon, Dec 20, 2010 at 11:12 AM, Felipe Contreras
> <felipe.contreras@nokia.com> wrote:
>> We need to protect not only the dmm_map list, but the individual
>> map_obj's, otherwise, we might be building the scatter-gather list with
>> garbage. So, use the existing proc_lock for that.
>>
>> I observed race conditions which caused kernel panics while running
>> stress tests. This patch fixes those.
>>
>> Signed-off-by: Felipe Contreras <felipe.contreras@nokia.com>
>> ---
>>  drivers/staging/tidspbridge/rmgr/proc.c |   18 ++++++++++++++----
>>  1 files changed, 14 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/tidspbridge/rmgr/proc.c b/drivers/staging/tidspbridge/rmgr/proc.c
>> index b47d7aa..21052e3 100644
>> --- a/drivers/staging/tidspbridge/rmgr/proc.c
>> +++ b/drivers/staging/tidspbridge/rmgr/proc.c
>> @@ -781,12 +781,14 @@ int proc_begin_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>>                                                        (u32)pmpu_addr,
>>                                                        ul_size, dir);
>>
>> +       mutex_lock(&proc_lock);
>
> May be you should use mutex_lock_interruptable instead of  mutex_lock.

Right, but I think that should be a separate patch since
mutex_lock(&proc_lock) is already being used.

>> @@ -819,12 +823,14 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>>                                                        (u32)pmpu_addr,
>>                                                        ul_size, dir);
>>
>> +       mutex_lock(&proc_lock);
>> +
>>        /* find requested memory are in cached mapping information */
>>        map_obj = find_containing_mapping(pr_ctxt, (u32) pmpu_addr, ul_size);
>>        if (!map_obj) {
>>                pr_err("%s: find_containing_mapping failed\n", __func__);
>>                status = -EFAULT;
>> -               goto err_out;
>> +               goto no_map;
>>        }
>>
>>        if (memory_regain_ownership(map_obj, (u32) pmpu_addr, ul_size, dir)) {
>> @@ -834,6 +840,8 @@ int proc_end_dma(void *hprocessor, void *pmpu_addr, u32 ul_size,
>>                goto err_out;
>
> Mutex is not released in this case as it is released only at no_map.

Oops! I didn't test proc_end_dma() and quickly added those locks after
I noticed it. I'll resend with the fix.

-- 
Felipe Contreras
