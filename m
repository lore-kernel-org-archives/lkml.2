Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0KIR43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:56:29 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51391 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab0KIR40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=oAYuStVdaA/w9DUZKrFk12ZNryWRGfOLIyoeWSj9CtrJ2eRUNq+msO+oXpirKip4Fs
         KZgkB2PNVnspSDiVpGpw==
MIME-Version: 1.0
In-Reply-To: <20101109142208.GB18269@hmsreliant.think-freely.org>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203334.22479.71661.stgit@crlf.mtv.corp.google.com> <20101109142208.GB18269@hmsreliant.think-freely.org>
From: Mike Waychison <mikew@google.com>
Date: Tue, 9 Nov 2010 09:56:02 -0800
Message-ID: <AANLkTik9i9pMqnngE-9t+Cc7cN6WbftjPoW6AWE6Va=x@mail.gmail.com>
Subject: Re: [PATCH v2 20/23] netoops: Add x86 specific bits to packet headers
To: Neil Horman <nhorman@tuxdriver.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 6:22 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> On Mon, Nov 08, 2010 at 12:33:35PM -0800, Mike Waychison wrote:
>> We need to be able to gather information about the CPUs that caused the crash.
>>
>> This commit only handles x86, but it is desirable to come up with some new
>> packet format that can accommodate any architecture.
>>
>> Signed-off-by: Mike Waychison <mikew@google.com>
>> ---
>> TODO: This should be made more general to other architectures.  As is, we are
>> probably okay exporting some value for the 'arch' field.  Different
>> architectures though will likely want to gather different data.
>> ---
>>  drivers/net/netoops.c |   27 +++++++++++++++++++++------
>>  1 files changed, 21 insertions(+), 6 deletions(-)
>>
> Not sure I see the value in encapsulating arch specific data in a netoops
> message.  Ostensibly this information can be inferred at the time of the crash
> by the name/ip of the system crashing (one presumes that the sysadmin knows what
> systems are what arch, or can look it up easily).

This actually becomes harder than it appears at first.  The
distributed nature of our systems means that we cannot ever rely on a
central data source that describes the machines we have without having
to worry about network partitions and service downtimes. The
alternative is to post-process crashes, looking up machine information
in various data sources and hoping that the results are consistent.
This becomes yet another job in the cluster, which seems a little
silly when we could just have the machine self describe itself at the
time of the crash.

>
> If thats not the case, why not just dump out the contents of /proc/cpuinfo in
> ascii form, so that no arch specific data is needed?

As a segment of the dump? I'm okay with doing this, as long it never
makes it's way into log_buf.  log_buf is a real pain to parse given
the lack of transactions and the fact that many other cores may be
scribbling all over it.

A couple years ago, we speced out a different wire protocol for these
packets, version 3 (yes, this has already had a version bump).
Anyhow, we came up with a design that used (key,length)->value fields.
  Keys were designed to be 16bit wide integers and clients could
easily ignore fields that it doesn't understand.  We never implemented
this, but it'd be great if folks bought into it.  It'd allow us to
ship things like file contents side by side with other structured
fields like pt_regs snapshots, the log_buf and a user defined buffer.

How do folks feel about something like that?
