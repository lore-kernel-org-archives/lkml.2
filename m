Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0IAHmN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 03:42:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57481 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0IAHmL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 03:42:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Aslpq98D2uuzHaBNGqXBS7XPB/o9K6QkNSRQniKD9M/tNKTmM8yQR646H6mCsyiPYl
         SVNRpwUGPy5IioYFJTuYhtghZqJoaFltTLkpzzcTQqapS3Jinqj7ZC1wQ9eTb5CezwrU
         iWyzJtXmSYvI7bVw9mjoW8EYfSeQNB6gL0mLg=
MIME-Version: 1.0
In-Reply-To: <20100901072016.GA27065@elte.hu>
References: <1283310009-22168-1-git-send-email-dzickus@redhat.com>
	<1283310009-22168-2-git-send-email-dzickus@redhat.com>
	<20100901053055.GA14316@elte.hu>
	<AANLkTim_O0CXMCv_qVDKOP72=VC63eoZuvpKWm=mme7k@mail.gmail.com>
	<AANLkTim1s=O6+OEvwLsaxbkpfyQk-Mypr5wE7H4fh9V0@mail.gmail.com>
	<20100901072016.GA27065@elte.hu>
Date: Wed, 1 Sep 2010 11:42:10 +0400
Message-ID: <AANLkTinv82=5Up0H8jevLuE-pvmKD6cej1MKmRPmbMd-@mail.gmail.com>
Subject: Re: [PATCH 1/3] [lockup detector] sync touch_*_watchdog back to old semantics
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Don Zickus <dzickus@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 1, 2010, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>> On 9/1/10, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>> > On 9/1/10, Ingo Molnar <mingo@elte.hu> wrote:
>> >>
>> >> * Don Zickus <dzickus@redhat.com> wrote:
>> >>
>> >>>  void touch_nmi_watchdog(void)
>> >>>  {
>> >>> - __get_cpu_var(watchdog_nmi_touch) = true;
>> >>> + if (watchdog_enabled) {
>> >>> +         unsigned cpu;
>> >>> +
>> >>> +         for_each_present_cpu(cpu) {
>> >>> +                 if (per_cpu(watchdog_nmi_touch, cpu) != true)
>> >>> +                         per_cpu(watchdog_nmi_touch, cpu) = true;
>> >>> +         }
>> >>
>> >> Hm, this is going to be a scalability nightmare with lots of CPUs. Not
>> >> only do we have a nr_cpus loop, but we touch per-cpu areas of _other_
>> >> CPUs - a big scalability nono.
>> >>
>> >> Why do we need to do this? We never needed to touch other CPU's NMI
>> >> lockup accounting data areas - why has this changed? The changelog does
>> >> not explain this.
>> >>
>> >> Thanks,
>> >>
>> >>    Ingo
>> >>
>> > I believe this came from old nmi watchdog code where it might be
>> > useful when nmi watchdog activated via io-apic. I'm trying to figure
>> > out if we really need it still.
>>
>> Well, we can't drop it or make per-cpu specific, for example we need
>> it in case of panic with watchdog enabled and panic timeout set, or
>> boot delay set and etc. Seems same applies to printk_delay. Hmm...
>
> Ok - can you cite the old watchdog code, did it really do a nr_cpus
> loop?
>
> Thanks,
>
>         Ingo
>

Yes, previous touch_nmi_watchdog really did a loop as
for_each_present_cpu and touching per-cpu variable

(bad format)

void touch_nmi_watchdog(void)
{
if (nmi_watchdog_active()) {
  unsigned cpu;
  for_each_present_cpu(cpu) {
    if (per_cpu(nmi_touch,cpu) != 1)
       per_cpu(nmi_touch, cpu) = 1;
    }
  }
touch_softlockup_watchdog();
}
