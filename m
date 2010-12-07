Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab0LGTfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 14:35:04 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:52480 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab0LGTfC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 14:35:02 -0500
MIME-Version: 1.0
In-Reply-To: <1291747731-sup-3099@think>
References: <AANLkTinG209iRAXgpNC0vNpn1C02wkYmVfveXRBqsKV-@mail.gmail.com>
 <4CF692D1.1010906@redhat.com> <AANLkTimA2PPXZoOHYgeOEV2ocrojeuBby8MYDYJ1yjx1@mail.gmail.com>
 <4CF6B3E8.2000406@redhat.com> <20101201212310.GA15648@redhat.com>
 <AANLkTimQtMvPVafWG_DffF-zXXpz1vBPXdCCwxRnzSGr@mail.gmail.com>
 <20101204193828.GB13871@redhat.com> <AANLkTin3A_ySn_sZQPqZMn-NORnteQZwTVVSiW_=r3sO@mail.gmail.com>
 <20101207142145.GA27861@think> <AANLkTikJt-ZOmzj68Jw92rjGHzu0EP-uCVD+eNSO=vGd@mail.gmail.com>
 <20101207182243.GB21112@redhat.com> <AANLkTikOXjh+D25=7Mzwn7bFN+a9xQSimPHs22q4o2TK@mail.gmail.com>
 <1291747731-sup-3099@think>
From: Jon Nelson <jnelson@jamponi.net>
Date: Tue, 7 Dec 2010 13:34:40 -0600
Message-ID: <AANLkTin-Bvq9bNgarZGZhbK_2EONdu8x-qaLCLFcc1F_@mail.gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
To: Chris Mason <chris.mason@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Matt <jackdachef@gmail.com>,
        Milan Broz <mbroz@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        dm-devel <dm-devel@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 7, 2010 at 12:52 PM, Chris Mason <chris.mason@oracle.com> wrote:
> Excerpts from Jon Nelson's message of 2010-12-07 13:45:14 -0500:
>> On Tue, Dec 7, 2010 at 12:22 PM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > On Tue, Dec 07 2010 at  1:10pm -0500,
>> > Jon Nelson <jnelson@jamponi.net> wrote:
>> >
>> >> I finally found some time to test this out. With 2.6.37-rc4 (openSUSE
>> >> KOTD kernel) I easily encounter the issue.
>> >>
>> >> Using a virtual machine, I created a stock, minimal openSUSE 11.3 x86_64
>> >> install, installed all updates, installed postgresql and the 'KOTD'
>> >> (Kernel of the Day)
>> >> kernel, and ran the following tests (as postgres user because I'm
>> >> lazy).
>> >>
>> >> 1. create a database (from bash):
>> >>
>> >> createdb test
>> >>
>> >> 2. place the following contents in a file (I used 't.sql'):
>> >>
>> >> begin;
>> >> create temporary table foo as select x as a, ARRAY[x] as b FROM
>> >> generate_series(1, 10000000 ) AS x;
>> >> create index foo_a_idx on foo (a);
>> >> create index foo_b_idx on foo USING GIN (b);
>> >> rollback;
>> >>
>> >> 3. execute that sql:
>> >>
>> >> psql -f t.sql --echo-all test
>> >>
>> >>
>> >> With 2.6.34.7 I can re-run [3] all day long, as many times as I want,
>> >> without issue.
>> >>
>> >> With 2.6.37-rc4-13 (the currently-installed KOTD kernel) if tails
>> >> pretty frequently.
>> >
>> > How does it fail?  postgres errors?  kernel errors?
>>
>> postgresql errors. Typically, header corruption but from the limited
>> visibility I've had into this via strace, what I see is zeroed pages
>> where there shouldn't be.
>
> This sounds a lot like a bug higher up than dm-crypt.  Zeros tend to
> come from some piece of code explicitly filling a page with zeros, and
> that often happens in the corner cases for O_DIRECT and a few other
> places in the filesystem.
>
> Have you tried triggering this with a regular block device?

I just tried the whole set of tests, but with /dev/sdb directly (as
ext4) without any crypt-y bits.
It takes more iterations but out of 6 tests I had one failure: same
type of thing, 'invalid page header in block ....'.

I can't guarantee that it is a full-page of zeroes, just what I saw
from the (limited) stracing I did.



-- 
Jon
