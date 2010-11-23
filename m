Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0KWBhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 20:37:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60569 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab0KWBhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 20:37:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jZYZG8dZSqWyxOBN/04zF0gLA1Lmcw7k/1PiLNgX/r0RZm9W+v1fixr2oS3xw7hYN+
         nAORv5UQPrq9LH5oExPCTzrLr2uUgszPG1rhF2+1dj/9TGJUWZa3P29iStDCoNn9E95X
         fs8mdgryZYyc16vqOd13fYZzylx+HfZa4J2RU=
MIME-Version: 1.0
In-Reply-To: <1290470763.3008.252.camel@localhost>
References: <1290470763.3008.252.camel@localhost>
Date: Mon, 22 Nov 2010 17:37:35 -0800
X-Google-Sender-Auth: upqDsl3Q643ZUeg478wR77hsPHw
Message-ID: <AANLkTi=MM-GVGcswHfLXE-6JFHiXUT4k-wt61rqwkjAf@mail.gmail.com>
Subject: Re: [RFC] persistent store
From: Tony Luck <tony.luck@intel.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 4:06 PM, Jim Keniston
<jkenisto@linux.vnet.ibm.com> wrote:
>> + /* Don't dump oopses to persistent store */
>
> Why not?  In our case, we capture every oops and panic report, but keep
> only the most recent.  Seems like catching the last oops could be useful
> if your system hangs thereafter and can't be made to panic.  I suggest
> you pass along the reason (KMSG_DUMP_OOPS or whatever) and let the
> callback decide.

My thoughts were that Oops were non-fatal and ended up in /var/log/messages,
so this would be unneeded (this bit of code was copied from one of mtdoops
or ramoops - which does almost the same ... they do have an option to
allow the copy - perhaps I should have copied that bit too?).

> You'd have to serialize the oops handling, I guess, in case multiple
> CPUs oops simultaneously.  (Gotta fix that in my code.)
Yup - I need to do this too (I only allocate one buffer).

>> + psinfo->writer(PSTORE_DMESG, pstore_buf, l1_cpy + l2_cpy);
>
> This assumes that you always want to capture the last psinfo->data_size
> bytes of the printk buffer.  Given the small capacity of our NVRAM
> partition, I handle the case where the whole oops report doesn't fit.
> In that case, I sacrifice the end of the oops report to capture the
> beginning.  Patch #3 in my set is about this.

Yes - I assume here that the last "data_size" bytes will be enough
to be useful. But in your case it most likely won't be.  You could
lie about how much space you allow and then include some oops
parsing code to get the vital bits out of what is passed to you. Not
pretty - but it would work. If there are many such devices with limited
capacity, then it would make sense to include this parsing code
in this generic layer.

>> + new_pstore->attr.attr.mode = 0444;
>
> /var/log/messages is typically not readable by everybody.  This
> appears to circumvent that.

But "dmesg(8)" typically *does* allow any user to see the most recent
part of the console log - so we are not consistent about this.

-Tony
