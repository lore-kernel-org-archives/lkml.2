Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab2HPVvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:51:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47174 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab2HPVvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:51:51 -0400
From: Anthony Liguori <anthony@codemonkey.ws>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tomas Racek <tracek@redhat.com>
Cc: qemu-devel@nongnu.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, kvm-devel <kvm@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [Qemu-devel] x86, nops settings result in kernel crash
In-Reply-To: <20120816195324.5356cba0@pyramind.ukuu.org.uk>
References: <20120816134834.GA11974@x1.osrc.amd.com> <1898701172.1847948.1345142715802.JavaMail.root@redhat.com> <20120816195324.5356cba0@pyramind.ukuu.org.uk>
User-Agent: Notmuch/0.13.2+93~ged93d79 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 16 Aug 2012 16:51:46 -0500
Message-ID: <87393msdxp.fsf@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Thu, 16 Aug 2012 14:45:15 -0400 (EDT)
> Tomas Racek <tracek@redhat.com> wrote:
>
>> ----- Original Message -----
>> > On Thu, Aug 16, 2012 at 09:35:12AM -0400, Tomas Racek wrote:
>> > > Hi,
>> > > 
>> > > I am writing a file system test which I execute in qemu with kernel
>> > > compiled from latest git sources and running it causes this error:
>> > > 
>> > > https://bugzilla.kernel.org/show_bug.cgi?id=45971
>> > > 
>> > > It works with v3.5, so I ran git bisect which pointed me to:
>> > > 
>> > > d6250a3f12edb3a86db9598ffeca3de8b4a219e9 x86, nops: Missing break
>> > > resulting in incorrect selection on Intel
>> > > 
>> > > To be quite honest, I don't understand this stuff much but I tried
>> > > to do some debugging and I figured out (I hope) that the crash is
>> > > caused by setting ideal_nops to p6_nops (k8_nops was used before
>> > > the break statement was added).
>> > 
>> > Maybe I overlooked it or maybe it was implied but did you try
>> > reverting
>> > the patch and rerunning your test? Does it work ok then?
>> > 
>> 
>> Yes, if I remove the break statement (introduced by this commit), it works fine.
>
> What version of qemu is this - do we have qemu bug here I wonder.

>From the cpuinfo, it's 0.15.1.  That's old but not ancient.

I took a brief look at the kernel code here.  The default invocation of
qemu presents an idealistic CPU with a very minimum feature bit set
exposed.  No processor has ever existed with this feature set.

We do this in order to maintain compatibility when migration from Intel
to AMD but also for legacy reasons.

>From the report, using '-cpu host' solves the problem.  '-cpu host'
exposes most of the host CPUID to the guest.

That said, QEMU really doesn't do anything differently depending on what
feature bits are exposed to the guest.  So my guess is that the odd
combination of CPUID bits that are exposed to the guest is confusing the
kernel.

Can you post dmesg from the host kernel?  Perhaps there's instruction
emulation failing in the host KVM?  That would manifest in strange
behavior in the guest.

Regards,

Anthony Liguori

>
> Alan
