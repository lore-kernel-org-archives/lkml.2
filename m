Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab2DIWJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 18:09:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62494 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2DIWJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 18:09:49 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
 <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
 <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com> <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Apr 2012 15:09:26 -0700
X-Google-Sender-Auth: kgjXywLThkdU_-TIoxQD-g9K_R4
Message-ID: <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Content-Type: multipart/mixed; boundary=f46d041824eeb06e2604bd464387
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d041824eeb06e2604bd464387
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 9, 2012 at 2:22 PM, David Rientjes <rientjes@google.com> wrote:
>
> NOTIFY_OK should never be a valid response for this notifier the way it's
> currently implemented, it should be NOTIFY_STOP to stop iterating the cal=
l
> chain to avoid a double free.

No, that's no good either. That would mean that some people wouldn't
be notified about the death of the task at all.

So NOTIFY_STOP just implies *another* bug.

> Right, we can't handoff the freeing of the task_struct to more than one
> notifier. =A0It seems misdesigned from the beginning and what we really w=
ant
> is to hijack task->usage for __put_task_struct(task) if we have such a
> notifier callchain and require each one (currently just oprofile) to take
> a reference on task->usage for NOTIFY_OK and then be responsible for
> dropping the reference when it's done with it later instead of requiring
> it to free the task_struct itself.

We could make notifier.c just "or" all the return values together, and
then it's ok if *one* person returns NOTIFY_OK.

Of course, that's not how notifiers are documented to work, but quite
frankly, notifiers with non-zero values that don't sat STOP are broken
as-is anyway, so you might we well do a logical "or" of the return
values and at least make things like this work.

I personally think every single notifier interface we have ever had in
the kernel has been a total f*cking disaster. The whole concept of
"run these random functions at this random event" is a broken concept
that just makes people do crazy broken things.

Oh well. So my suggestion right now would be something like the
attached. It's still horribly broken, it actively breaks documented
notifier behavior, but dammit, if the notifier people don't like
'or'ing return values together they should damn well return zero from
the notifier that doesn't do anything. And returning an error will
exit out, so..

Hmm? Who cares about that kernel/notifier.c code? Andrew? Ingo? We
don't have any actual maintainer for that crap, but judging by the
commits, it's one of you two.

                  Linus

--f46d041824eeb06e2604bd464387
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h0u2pjnd0

IGRyaXZlcnMvc3RhZ2luZy9hbmRyb2lkL2xvd21lbW9yeWtpbGxlci5jIHwgICAgMiArLQoga2Vy
bmVsL25vdGlmaWVyLmMgICAgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiAyIGZpbGVz
IGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9k
cml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9sb3dtZW1vcnlraWxsZXIuYyBiL2RyaXZlcnMvc3RhZ2lu
Zy9hbmRyb2lkL2xvd21lbW9yeWtpbGxlci5jCmluZGV4IDA1MmI0M2U0ZTUwNS4uMTQyYmZjMmY4
NGRiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9sb3dtZW1vcnlraWxsZXIu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvYW5kcm9pZC9sb3dtZW1vcnlraWxsZXIuYwpAQCAtNzks
NyArNzksNyBAQCB0YXNrX25vdGlmeV9mdW5jKHN0cnVjdCBub3RpZmllcl9ibG9jayAqc2VsZiwg
dW5zaWduZWQgbG9uZyB2YWwsIHZvaWQgKmRhdGEpCiAJaWYgKHRhc2sgPT0gbG93bWVtX2RlYXRo
cGVuZGluZykKIAkJbG93bWVtX2RlYXRocGVuZGluZyA9IE5VTEw7CiAKLQlyZXR1cm4gTk9USUZZ
X09LOworCXJldHVybiBOT1RJRllfRE9ORTsKIH0KIAogc3RhdGljIGludCBsb3dtZW1fc2hyaW5r
KHN0cnVjdCBzaHJpbmtlciAqcywgc3RydWN0IHNocmlua19jb250cm9sICpzYykKZGlmZiAtLWdp
dCBhL2tlcm5lbC9ub3RpZmllci5jIGIva2VybmVsL25vdGlmaWVyLmMKaW5kZXggMmQ1Y2M0Y2Nm
ZjdmLi4xMWZlOTU2ZThkYWYgMTAwNjQ0Ci0tLSBhL2tlcm5lbC9ub3RpZmllci5jCisrKyBiL2tl
cm5lbC9ub3RpZmllci5jCkBAIC05MCw3ICs5MCw3IEBAIHN0YXRpYyBpbnQgX19rcHJvYmVzIG5v
dGlmaWVyX2NhbGxfY2hhaW4oc3RydWN0IG5vdGlmaWVyX2Jsb2NrICoqbmwsCiAJCQljb250aW51
ZTsKIAkJfQogI2VuZGlmCi0JCXJldCA9IG5iLT5ub3RpZmllcl9jYWxsKG5iLCB2YWwsIHYpOwor
CQlyZXQgfD0gbmItPm5vdGlmaWVyX2NhbGwobmIsIHZhbCwgdik7CiAKIAkJaWYgKG5yX2NhbGxz
KQogCQkJKCpucl9jYWxscykrKzsK
--f46d041824eeb06e2604bd464387--
