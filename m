Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab1EDQGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:06:33 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47243 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540Ab1EDQGb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:06:31 -0400
Message-ID: <4DC17839.9020905@us.ibm.com>
Date: Wed, 04 May 2011 11:00:57 -0500
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: durga prasad <durgaprasad21@gmail.com>
CC: Robert Richter <robert.richter@amd.com>, Nicolas Kaiser <nikai@nikai.net>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>
Subject: Re: [PATCH resend] s390: oprofile: fix error checks in oprofile_hwsampler_init()
References: <20110502154805.71664123@absol.kitzblitz> <20110503085540.GX31407@erda.amd.com> <BANLkTikC6vQF3p91q8e2E1Rp2M2HYyKipQ@mail.gmail.com>
In-Reply-To: <BANLkTikC6vQF3p91q8e2E1Rp2M2HYyKipQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2011 2:49 AM, durga prasad wrote:
>
> Thanks for the reply.
Durga, you're replying to the wrong thread.

-Maynard

> I can able to run oprofile on the target(ARM V7-CA9) in timer mode.
> The problem of Bad magic number is because of the JFFS2 file system.So I mounted
> usb on the target and colleted the sample on the target.
> I am able to analyze the sample on the target.But for analyzing the samples on
> the host I am doing the follows process.
>
> I mounted the USB to /var/lib/oprofile -- so the sample will be collected
> directly to USB
>
> After the I am running oparchieve on the target
>
> *oparchive -o /var/lib/oprofile/durga/*
>
> I am doing opimport on the host PC
>
> *# opimport -V -a /media/Pen_drive/durga/ -o /home/durga/oprofile/
>    error: must specify exactly 1 input file
>
> *I am getting the above error always.*
> *How to analyze the sample collected in the Host PC after collecting the samples
> in Pen drive from target*?
>
>
> *Your *help* will *be* warmly received.
>
> Regards,
> Durga Prasad
> *
>
>
> *
>
>
>
>
> On Tue, May 3, 2011 at 5:55 PM, Robert Richter <robert.richter@amd.com
> <mailto:robert.richter@amd.com>> wrote:
>
>     On 02.05.11 09:48:05, Nicolas Kaiser wrote:
>     >  Checking 'oprofile_min_interval < 0' and
>     >  'oprofile_max_interval < 0' doesn't work because
>     >  'oprofile_min_interval' and 'oprofile_max_interval' are unsigned.
>
>     max/min_interval are through all the code always unsigned. I don't
>     know how min/max_sampl_rate in struct hws_qsi_info_block is spec'ed,
>     but there it is unsigned too.
>
>     So the best would be to return qsi.min/max_sampl_rate in
>     hwsampler_query_min/max_interval() directly with no error codes as
>     unsigned longs and to change the code in oprofile_hwsampler_init() to
>     check for null. Both functions hwsampler_query_min/max_interval()
>     could be moved to hwsampler.h as static inline functions. This makes
>     the code also easier.
>
>     This patch does not handle the null value case and the data truncation
>     by casting from unsigned to singed is not fixed.
>
>     -Robert
>
>     >
>     >  Signed-off-by: Nicolas Kaiser <nikai@nikai.net <mailto:nikai@nikai.net>>
>     >  ---
>     >  Untested.
>     >
>     >   arch/s390/oprofile/init.c |   12 ++++++++----
>     >   1 files changed, 8 insertions(+), 4 deletions(-)
>     >
>     >  diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
>     >  index c63d7e5..09c3088 100644
>     >  --- a/arch/s390/oprofile/init.c
>     >  +++ b/arch/s390/oprofile/init.c
>     >  @@ -138,22 +138,26 @@ static int oprofile_create_hwsampling_files(struct
>     super_block *sb,
>     >
>     >   static int oprofile_hwsampler_init(struct oprofile_operations *ops)
>     >   {
>     >  +     long retval;
>     >  +
>     >        if (hwsampler_setup())
>     >                return -ENODEV;
>     >
>     >        /*
>     >         * create hwsampler files only if hwsampler_setup() succeeds.
>     >         */
>     >  -     oprofile_min_interval = hwsampler_query_min_interval();
>     >  -     if (oprofile_min_interval < 0) {
>     >  +     retval = hwsampler_query_min_interval();
>     >  +     if (retval < 0) {
>     >                oprofile_min_interval = 0;
>     >                return -ENODEV;
>     >        }
>     >  -     oprofile_max_interval = hwsampler_query_max_interval();
>     >  -     if (oprofile_max_interval < 0) {
>     >  +     oprofile_min_interval = retval;
>     >  +     retval = hwsampler_query_max_interval();
>     >  +     if (retval < 0) {
>     >                oprofile_max_interval = 0;
>     >                return -ENODEV;
>     >        }
>     >  +     oprofile_max_interval = retval;
>     >
>     >        if (oprofile_timer_init(ops))
>     >                return -ENODEV;
>     >  --
>     >  1.7.3.4
>     >
>
>     --
>     Advanced Micro Devices, Inc.
>     Operating System Research Center
>
>
>     ------------------------------------------------------------------------------
>     WhatsUp Gold - Download Free Network Management Software
>     The most intuitive, comprehensive, and cost-effective network
>     management toolset available today.  Delivers lowest initial
>     acquisition cost and overall TCO of any competing solution.
>     http://p.sf.net/sfu/whatsupgold-sd
>     _______________________________________________
>     oprofile-list mailing list
>     oprofile-list@lists.sourceforge.net <mailto:oprofile-list@lists.sourceforge.net>
>     https://lists.sourceforge.net/lists/listinfo/oprofile-list
>
>
>
>
> --
> regards
> prasad.....

