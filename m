Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab1FPJJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:09:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40743 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab1FPJJD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:09:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VaUK93bchuAvW9pVmLlz2khD2li1hWGvx8uMiJDIrgWY9wt1e0yh9R9PL7iwktjXDi
         yyNcvc2kwO9ww5d3txA9+N2zMcAwSamqR1lKMUPrcb1LhNGn/PtA2ziSLBJK1nA9PV6t
         6S9JkxtwMnQ3H+HHsILwSZg/6Cowtrc71GVEo=
MIME-Version: 1.0
In-Reply-To: <20110616072452.GA15366@elte.hu>
References: <1308153214.7566.6.camel@jaguar>
	<4DF8DE26.1070301@redhat.com>
	<BANLkTi=SHENDBHdtFY_7_qtfqJb_+qKJSw@mail.gmail.com>
	<BANLkTinMDz-sqaX0cyWEoLXt70dowxofvg@mail.gmail.com>
	<4DF92C80.3030106@codemonkey.ws>
	<7A30A509-47AA-4E72-ABF3-937005900F9D@suse.de>
	<BANLkTi=Jm_50m6qyfQPCF0PuwUfuDNwMtg@mail.gmail.com>
	<20110616072452.GA15366@elte.hu>
Date: Thu, 16 Jun 2011 10:09:01 +0100
Message-ID: <BANLkTi=j1EqMP7gwKKUYOCv4OET1N8uJrQ@mail.gmail.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Alexander Graf <agraf@suse.de>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 8:24 AM, Ingo Molnar <mingo@elte.hu> wrote:
>  - executing AIO in the vcpu thread eats up precious vcpu execution
>   time: combined QCOW2 throughput would be limited by a single
>   core's performance, and any time spent on QCOW2 processing would
>   not be spent running the guest CPU. (In such a model we certainly
>   couldnt do more intelligent, CPU-intense storage solutions like on
>   the fly compress/decompress of QCOW2 data.)

This has been a problem in qemu-kvm.  io_submit(2) steals time from
the guest (I think it was around 20us on the system I measured last
year).

Add the fact that the guest kernel might be holding a spinlock and it
becomes a scalability problem for SMP guests.

Anything that takes noticable CPU time should be done outside the vcpu thread.

Stefan
