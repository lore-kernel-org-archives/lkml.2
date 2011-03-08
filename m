Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1CHRfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 12:35:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24219 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab1CHRfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 12:35:11 -0500
Message-ID: <4D7668C5.5050100@redhat.com>
Date: Tue, 08 Mar 2011 18:35:01 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>, dm-crypt@saout.de,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-crypt] dm-crypt: Performance Regression 2.6.37 -> 2.6.38-rc8
References: <20110308164508.GA8729@darkside.kls.lan>
In-Reply-To: <20110308164508.GA8729@darkside.kls.lan>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2011 05:45 PM, Mario 'BitKoenig' Holbe wrote:
> dm-crypt in 2.6.38 changed to per-CPU workqueues to increase it's
> performance by parallelizing encryption to multiple CPUs.
> This modification seems to cause (massive) performance drops for
> multiple parallel dm-crypt instances...
> 
> I'm running a 4-disk RAID0 on top of 4 independent dm-crypt(aes-xts)
> devices on a Core2Quad 3GHz. This setup did overcome the single-CPU
> limitation from previous versions and utilized all 4 cores for
> encryption.
> The throughput of this array drops from 282MB/s sustained read (dd,
> single process) with 2.6.37.3 down to 133MB/s with 2.6.38-rc8 (which
> nearly equals to single-disk throughput of 128MB/s - just in case this
> matters).
> 
> This indicates way less parallelization now with 2.6.38 than before.
> I don't think this was intentional :)

Well, it depends. I never suggested this kind of workaround because
you basically hardcoded (in device stacking) how many parallel instances
(==cpu cores ideally) of dmcrypt can run effectively.

Previously there was no cpu affinity, so dmcrypt thread simply run
on some core.

With current design the IO is encrypted by the cpu which submitted it.

If you have RAID0 it probably means that one IO is split into stripes
and these try to encrypt on the same core (in "parallel"). 
(I need to test what actually happens though.)

If you use one dmcrypt instance over RAID0, you will now get probably
much more better throughput. (Even with one process generating IOs
the bios are, surprisingly, submitted on different cpus. But this time
it runs really in parallel.)

Maybe we can find some compromise but I basically prefer current design,
which provides much more better behaviour for most of configurations.

Milan
