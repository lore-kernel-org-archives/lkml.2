Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480Ab2EYVnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:43:22 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54870 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2EYVnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:43:20 -0400
MIME-Version: 1.0
In-Reply-To: <87wr40ko8j.fsf@xmission.com>
References: <1337889128.10617.YahooMailClassic@web84515.mail.ne1.yahoo.com> <87wr40ko8j.fsf@xmission.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 25 May 2012 14:42:59 -0700
X-Google-Sender-Auth: OAvTxhc9J2sMMs4oWdzIGnnoChI
Message-ID: <CA+55aFw9eaKdx9-j1tXxKcRcOzfEiOKgnP+p1hu8WVhs9tu4FQ@mail.gmail.com>
Subject: Re: Regression Mounting /proc w/ kernel 3.4.0 - "uid" parameter no
 longer ignored.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: kd6lvw@yahoo.com, linux-kernel@vger.kernel.org,
        Vasiliy Kulikov <segoon@openwall.com>,
        Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=001636c5a6f1b4a6c504c0e34107
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636c5a6f1b4a6c504c0e34107
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Heh.

If it is *only* uid, maybe we should just expressly ignore it. Like
the (completely untested) attached patch.

Hmm?

                  Linus

On Fri, May 25, 2012 at 1:19 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> kd6lvw@yahoo.com writes:
>
>> --- On Thu, 5/24/12, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> "D. Stussy" <spam+newsgroups@bde-arc.ampr.org> writes:
>>> > proc:=A0 unrecognized mount option "uid=3D1" or missing value
>>> >
>>> > This works under 3.3.6 and earlier (I never tried 3.3.7).=A0 It appea=
rs that the
>>> > "uid" mount option was removed.=A0 WHY?=A0 More importantly, where is=
 this change
>>> > listed?=A0 I didn't see it in the git log.
>>> >
>>> > This is really bad as I rebooted a remotely colocated server and sinc=
e the
>>> > procfs is not mounted, I cannot log in via SSH to correct the problem=
.
>>> >
>>> > OK, so there's not that much point in changing the UID of the procfs =
files, but
>>> > I preferred to set their default ownership to a non-privileged user.
>>>
>>> There has never been a uid=3D option to /proc in Linus's tree.=A0 I bel=
ieve
>>> if you look you will find this feature was from a patch (perhaps from
>>> your distro) that added that support.
>>
>> I compile both the util-linux-ng and the kernel from source.=A0 There is=
 no distribution patch involved.=A0 As noted, kernel version 3.3.6 didn't b=
itch about the setting, while 3.4.0 does and won't mount procfs.
>>
>> From the man page (copy at "http://linux.die.net/man/8/mount"):
>>
>> "Mount options for proc
>>
>> =A0 =A0=A0=A0"uid=3Dvalue and gid=3Dvalue
>>
>> "These options are recognized, but have no effect as far as I can see."
>>
>>
>> Removal of this compatibility should have been noted.=A0 WHERE was it
>> noted?=A0 Linux.die.net is a distribution independent documentation
>> site. =A0It might not do anything, but per mount's documentation, it is
>> acceptable.
>
> The only possible change to /proc that could have cause this behavior
> between 3.3 and 3.4 is below.
>
> Not ignoring options seems to be a regression that has affected your
> setup on 3.4.
>
> My gut feel is that we should revert all of the /proc option parsing
> code as it is ugly code and apparently it could not have been used
> before 3.4 so no one can be depending on it. =A0But I just want an excuse
> to get rid of ugly code. =A0Accepting that /proc ignores all options
> passed ot it as part of the ABI and not being able to add any options
> to /proc ever is also a pretty horrible state to be in.
>
> Shrug I will let you and the parties involved in creating this
> regression figure this out.
>
> Eric
>
> ommit 99663be772c827b8f5f594fe87eb4807be1994e5
> Author: Vasiliy Kulikov <segoon@openwall.com>
> Date: =A0 Thu Apr 5 14:25:04 2012 -0700
>
> =A0 =A0proc: fix mount -t proc -o AAA
>
> =A0 =A0The proc_parse_options() call from proc_mount() runs only once at =
boot
> =A0 =A0time. =A0So on any later mount attempt, any mount options are igno=
red
> =A0 =A0because ->s_root is already initialized.
>
> =A0 =A0As a consequence, "mount -o <options>" will ignore the options. =
=A0The
> =A0 =A0only way to change mount options is "mount -o remount,<options>".
>
> =A0 =A0To fix this, parse the mount options unconditionally.
>
> =A0 =A0Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> =A0 =A0Reported-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
> =A0 =A0Tested-by: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
> =A0 =A0Cc: Alexey Dobriyan <adobriyan@gmail.com>
> =A0 =A0Cc: Al Viro <viro@zeniv.linux.org.uk>
> =A0 =A0Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
> =A0 =A0Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> =A0 =A0Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> diff --git a/fs/proc/root.c b/fs/proc/root.c
> index 46a15d8..eed44bf 100644
> --- a/fs/proc/root.c
> +++ b/fs/proc/root.c
> @@ -115,12 +115,13 @@ static struct dentry *proc_mount(struct file_system=
_type *fs_type,
> =A0 =A0 =A0 =A0if (IS_ERR(sb))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return ERR_CAST(sb);
>
> + =A0 =A0 =A0 if (!proc_parse_options(options, ns)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 deactivate_locked_super(sb);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-EINVAL);
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (!sb->s_root) {
>

--001636c5a6f1b4a6c504c0e34107
Content-Type: application/octet-stream; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h2ns1e860

IGZzL3Byb2Mvcm9vdC5jIHwgOCArKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDcgaW5zZXJ0aW9u
cygrKSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2ZzL3Byb2Mvcm9vdC5jIGIvZnMvcHJv
Yy9yb290LmMKaW5kZXggN2MzMGZjZTAzN2MwLi5iMWRlMDRmNmU0MWIgMTAwNjQ0Ci0tLSBhL2Zz
L3Byb2Mvcm9vdC5jCisrKyBiL2ZzL3Byb2Mvcm9vdC5jCkBAIC0zOCwxMiArMzgsMTMgQEAgc3Rh
dGljIGludCBwcm9jX3NldF9zdXBlcihzdHJ1Y3Qgc3VwZXJfYmxvY2sgKnNiLCB2b2lkICpkYXRh
KQogfQogCiBlbnVtIHsKLQlPcHRfZ2lkLCBPcHRfaGlkZXBpZCwgT3B0X2VyciwKKwlPcHRfZ2lk
LCBPcHRfaGlkZXBpZCwgT3B0X3VpZCwgT3B0X2VyciwKIH07CiAKIHN0YXRpYyBjb25zdCBtYXRj
aF90YWJsZV90IHRva2VucyA9IHsKIAl7T3B0X2hpZGVwaWQsICJoaWRlcGlkPSV1In0sCiAJe09w
dF9naWQsICJnaWQ9JXUifSwKKwl7T3B0X3VpZCwgInVpZD0ldSJ9LAkvLyBpZ25vcmVkCiAJe09w
dF9lcnIsIE5VTEx9LAogfTsKIApAQCAtNjksNiArNzAsMTEgQEAgc3RhdGljIGludCBwcm9jX3Bh
cnNlX29wdGlvbnMoY2hhciAqb3B0aW9ucywgc3RydWN0IHBpZF9uYW1lc3BhY2UgKnBpZCkKIAkJ
CQlyZXR1cm4gMDsKIAkJCXBpZC0+cGlkX2dpZCA9IG1ha2Vfa2dpZChjdXJyZW50X3VzZXJfbnMo
KSwgb3B0aW9uKTsKIAkJCWJyZWFrOworCQljYXNlIE9wdF91aWQ6CisJCQlpZiAobWF0Y2hfaW50
KCZhcmdzWzBdLCAmb3B0aW9uKSkKKwkJCQlyZXR1cm4gMDsKKwkJCS8qIGlnbm9yZSBpdCAqLwor
CQkJYnJlYWs7CiAJCWNhc2UgT3B0X2hpZGVwaWQ6CiAJCQlpZiAobWF0Y2hfaW50KCZhcmdzWzBd
LCAmb3B0aW9uKSkKIAkJCQlyZXR1cm4gMDsK
--001636c5a6f1b4a6c504c0e34107--
