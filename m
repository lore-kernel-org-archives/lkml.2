Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab0KAP66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:58:58 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63328 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757626Ab0KAP6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=Ew7xZSH3dvyt9cCAduBfEmzQURMUE82aVA+QDqmuXT2caNo5j82Bp4t9bCuNQNGP98
         qpv/iG0vwkO+wdjhcYAcMnGCXP+82QEyRz1S8OpF93zc6S96QZqqub7sIJQbmCgyNMXv
         GKpJM807TFAeYht0JKkv4hmydPnePyfaP0fFw=
MIME-Version: 1.0
In-Reply-To: <20101031224757.GA2430@selene>
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
	<AANLkTikNywvthaU-+s5HXvh3RX=HxiFWmADW--Ln_Gga@mail.gmail.com>
	<AANLkTimgCU1tM9VJv8RJ-dim+bRsT7cbZ9ZidbT5sco-@mail.gmail.com>
	<20101031224757.GA2430@selene>
Date: Mon, 1 Nov 2010 17:58:52 +0200
Message-ID: <AANLkTingbRtFQUoQNZmQubL0LNhVF2hvkdma6j7VDTEU@mail.gmail.com>
Subject: Re: Horrible btrfs performance due to fragmentation
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Hugo Mills <hugo-lkml@carfax.org.uk>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        cwillu <cwillu@cwillu.com>, Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 1, 2010 at 12:47 AM, Hugo Mills <hugo-lkml@carfax.org.uk> wrote:
> On Mon, Nov 01, 2010 at 12:36:58AM +0200, Felipe Contreras wrote:
>> On Mon, Nov 1, 2010 at 12:25 AM, cwillu <cwillu@cwillu.com> wrote:
>> > btrfs fi defrag isn't recursive.  "btrfs filesystem defrag /home" will
>> > defragment the space used to store the folder, without touching the
>> > space used to store files in that folder.
>>
>> Yes, that came up on the IRC, but:
>>
>> 1) It doesn't make sense: "btrfs filesystem" doesn't allow a fileystem
>> as argument? Why would anyone want it to be _non_ recursive?
>
>   You missed the subsequent discussion on IRC about the interaction
> of COW with defrag. Essentially, if you've got two files that are COW
> copies of each other, and one has had something written to it since,
> it's *impossible* for both files to be defragmented, without making a
> full copy of both:
>
> Start with a file (A, etc are data blocks on the disk):
>
> file1 = ABCDEF
>
> Cow copy it:
>
> file1 = ABCDEF
> file2 = ABCDEF
>
> Now write to one of them:
>
> file1 = ABCDEF
> file2 = ABCDxF
>
>   So, either file1 is contiguous, and file2 is fragmented (with the
> block x somewhere else on disk), or file2 is contiguous, and file1 is
> fragmented (with E somewhere else on disk). In fact, we've determined
> by experiment that when you defrag a file that's sharing blocks with
> another one, the file gets copied in its entirety, thus separating the
> blocks of the file and its COW duplicate.

Ok, but the fragmentation would not be an issue in this case.

>> 2) The filesystem should not degrade performance so horribly no matter
>> how long the it has been used. Even git has automatic garbage
>> collection.
>
>   Since, I believe, btrfs uses COW very heavily internally for
> ensuring consistency, you can end up with fragmenting files and
> directories very easily. You probably need some kind of scrubber that
> goes looking for non-COW files that are fragmented, and defrags them
> in the background.

Or when going through all the fragments of a file, have a counter, and
if it exceeds certain limit mark it somehow, so that it gets
defragmented at least to a certain extent.

-- 
Felipe Contreras
