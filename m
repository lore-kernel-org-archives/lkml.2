Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2CMPkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:40:18 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64609 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756286Ab2CMPkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:40:16 -0400
MIME-Version: 1.0
In-Reply-To: <026393583fec46a9d4401604e596b164.squirrel@webmail.greenhost.nl>
References: <1331587715-26069-1-git-send-email-wad@chromium.org>
	<026393583fec46a9d4401604e596b164.squirrel@webmail.greenhost.nl>
Date: Tue, 13 Mar 2012 10:40:11 -0500
Message-ID: <CABqD9hZKny+7YOhUtNkcZ0-bfM10MpdoiuYu-9X8Wq99Qk-mQg@mail.gmail.com>
Subject: Re: [PATCH v14 01/13] sk_run_filter: add BPF_S_ANC_SECCOMP_LD_W
From: Will Drewry <wad@chromium.org>
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        netdev@vger.kernel.org, x86@kernel.org, arnd@arndb.de,
        davem@davemloft.net, hpa@zytor.com, mingo@redhat.com, oleg@redhat.com,
        peterz@infradead.org, rdunlap@xenotime.net, mcgrathr@chromium.org,
        tglx@linutronix.de, luto@mit.edu, eparis@redhat.com,
        serge.hallyn@canonical.com, djm@mindrot.org, scarybeasts@gmail.com,
        pmoore@redhat.com, akpm@linux-foundation.org, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:40 PM, Indan Zupancic <indan@nul.nu> wrote:
> Hello,
>
> On Mon, March 12, 2012 22:28, Will Drewry wrote:
>> Introduces a new BPF ancillary instruction that all LD calls will be
>> mapped through when skb_run_filter() is being used for seccomp BPF.  The
>> rewriting will be done using a secondary chk_filter function that is run
>> after skb_chk_filter.
>>
>> The code change is guarded by CONFIG_SECCOMP_FILTER which is added,
>> along with the seccomp_bpf_load() function later in this series.
>>
>> This is based on http://lkml.org/lkml/2012/3/2/141
>>
>> v14: First cut using a single additional instruction
>> ... v13: made bpf functions generic.
>>
>>
>> Suggested-by: Indan Zupancic <indan@nul.nu>
>> Signed-off-by: Will Drewry <wad@chromium.org>
>> ---
>>  include/linux/filter.h |    1 +
>>  net/core/filter.c      |    5 +++++
>>  2 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/filter.h b/include/linux/filter.h
>> index 8eeb205..aaa2e80 100644
>> --- a/include/linux/filter.h
>> +++ b/include/linux/filter.h
>> @@ -228,6 +228,7 @@ enum {
>>       BPF_S_ANC_HATYPE,
>>       BPF_S_ANC_RXHASH,
>>       BPF_S_ANC_CPU,
>> +     BPF_S_ANC_SECCOMP_LD_W,
>>  };
>>
>>  #endif /* __KERNEL__ */
>> diff --git a/net/core/filter.c b/net/core/filter.c
>> index 5dea452..3000931 100644
>> --- a/net/core/filter.c
>> +++ b/net/core/filter.c
>> @@ -350,6 +350,11 @@ load_b:
>>                               A = 0;
>>                       continue;
>>               }
>> +#ifdef CONFIG_SECCOMP_FILTER
>> +             case BPF_S_ANC_SECCOMP_LD_W:
>> +                     A = seccomp_bpf_load(fentry->k);
>
> I think you forgot to declare seccomp_bpf_load() anywhere filter.c can find.
> That is, filter.c probably needs to include seccomp.h, or maybe better, add
> "extern u32 seccomp_bpf_load(int off);" to filter.h instead.

Doh, it should include seccomp.h.  Right now it gets that on accident
via sched.h.  Since at this point in the patch series, the function
doesn't exist, I'd prefer to just add seccomp.h explicitly.  I'll do
that in the next version unless there is a clear problem.  (In
practice, it is already pulled in.)


> Reviewed-by: Indan Zupancic <indan@nul.nu>

Thanks!
will
