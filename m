Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449Ab0KDD1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 23:27:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61540 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0KDD1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 23:27:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=E2T1jIcalKw9koB/dCoBCWnPRQKMigdWCqzpykhUW636y559pqLPZXgxgw1q2mUavT
         nD6j2OGgN8G7LRPjK9XnwSgqIft5XkIqzT0duEtUZAFI9QPzl7h8fw4ICqwj0usnCXvW
         qAO31hFVLZWBL11acXfLdPKPukZmjUYoO/aas=
Date: Thu, 4 Nov 2010 11:31:48 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        "mrubin@google.com" <mrubin@google.com>,
        "david@fromorbit.com" <david@fromorbit.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1] /proc/vmstat failure.
Message-ID: <20101104033148.GB5210@cr0.nay.redhat.com>
References: <201011010053.ADE86905.JMLFHVtSQOOFOF@I-love.SAKURA.ne.jp>
 <201011032011.BAB21899.OHVQtFLSFJMFOO@I-love.SAKURA.ne.jp>
 <20101103174643.GA4985@localhost>
 <201011040654.GDB05271.SOFJFFtOMLHOQV@I-love.SAKURA.ne.jp>
 <20101104022052.GA7800@localhost>
 <20101104025251.GA5210@cr0.nay.redhat.com>
 <20101104025341.GA18429@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101104025341.GA18429@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 10:53:41AM +0800, Wu Fengguang wrote:
>On Thu, Nov 04, 2010 at 10:52:51AM +0800, Américo Wang wrote:
>> On Thu, Nov 04, 2010 at 10:20:52AM +0800, Wu Fengguang wrote:
>> >On Thu, Nov 04, 2010 at 05:54:48AM +0800, Tetsuo Handa wrote:
>> >> Wu Fengguang wrote:
>> >> > On Wed, Nov 03, 2010 at 07:11:11PM +0800, Tetsuo Handa wrote:
>> >> > > Hello.
>> >> > > 
>> >> > > "cat /proc/vmstat" triggered below failure.
>> >> > > 
>> >> > > BUG: unable to handle kernel paging request at 07c06d16
>> >> > > IP: [<c050c336>] strnlen+0x6/0x20
>> >> > 
>> >> > It seems that m->private is of type (void *) while the original v is
>> >> > (unsigned long *). Can be fixed by the following patch.
>> >> 
>> >> Fixed by this patch. Thank you.
>> >
>> >Great, thanks!
>> >
>> >> By the way, GCC treats "(void *) + offset" as "(char *) + offset"
>> >> but it is GCC specific extention. Maybe we should avoid such usage
>> >> in order to avoid build failure for other compilers.
>> >
>> >"(void *) + offset" seems to be used quite often.
>> >
>> >I tried enable this gcc option, only to see huge amount of warnings.
>> >
>> >       -Wpointer-arith
>> >           Warn about anything that depends on the "size of" a
>> >           function type or of "void".  GNU C assigns these types a
>> >           size of 1, for convenience in calculations with "void *"
>> >           pointers and pointers to functions.
>> >
>> 
>> Yup! I think it is good to have this.
>> 
>> >/cc/linux-next/scripts/mod/file2alias.c:88: warning: pointer of type ‘void *’ used in arithmetic
>> ...
>> >/cc/linux-next/scripts/mod/modpost.c:1565: warning: pointer of type ‘void *’ used in arithmetic
>> >
>> 
>> No problem, this is from kbuild and most of them that I checked are actually fine,
>> we can send patches to remove these warnings.
>
>Confirmed. Now my full kernel build is complete and the above are the
>only warnings I see. So it should be easy to add the -Wpointer-arith
>check.
>

Well, after I tried to compile with it, I got lots of warnings.
Most of them that I checked is something like:

 (void *) CONST_PTR + OFFSET

in macros. In order to fix this, we need to:

 (void *) ((char *) CONST_PTR + OFFSET)

So, we have to make some efforts to kill all the warnings. :-/
