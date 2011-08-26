Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab1HZQ2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 12:28:42 -0400
Received: from nm18-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.23]:29481
	"HELO nm18-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752179Ab1HZQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 12:28:37 -0400
X-Yahoo-Newman-Id: 743974.91193.bm@smtp102.biz.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6IVwtOMVM1naDoCChQUuuic6i23auH.e0whufLlq_qWV58d
 cNfCKZgL944JRGIDzLA.cU8IwiH43fqAHSpa1v3ud3W6r_G.oSkoqZENe1ni
 IPxy6gNlaYCpwTO.tYewjKBwLwSdwAG.6Jbrszcn_kCv2rvzIPP8N5V71NsC
 X6FS1JjKfG6z6t3fsG6yfpdwXNtcg2O3au92JnWpJONvjPqLg8qHp1aRHc1l
 5LX2g4xwzqPsjPGjYPUn1i1zbg4A21jQld87cAYbdG0vTBR2jP8xE4HGafLY
 RcXRMabjbCj3hlOiTVCrQE8bIQV8DznXczVL8UIaUoFUDzagCjZtspTdVg1N
 phlVNXOCo047HbzhkBbyGLYr6OY6gvW3SxwSgZXJt0QrQ3qITBMA59pitUo0
 aLr2eMw5dbE2CZrrI68FPIjP7sBe__5EBroWW8ugxSbTspitpyiJYG4vbHZe
 AMdhSFc0PdWu47mDMoOmI9tnBMupyLSZTGETd2wb6FzJSozTvJxgjVzcTQyr
 P00HELoSxeCEtwToKMpu6Nncwq7s-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4E57C93C.3050602@schaufler-ca.com>
Date: Fri, 26 Aug 2011 09:26:36 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Jarkko Sakkinen <jarkko.sakkinen@intel.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] Smack: SMACK_IOCLOADACCESS
References: <1314337927-17210-1-git-send-email-jarkko.sakkinen@intel.com> <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>
In-Reply-To: <CACLa4pvbaWM8jRJvBW2NvN2OLK8x4wP44pfdUQ9He1fZwWYcfA@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/2011 5:50 AM, Eric Paris wrote:
> On Fri, Aug 26, 2011 at 1:52 AM, Jarkko Sakkinen
> <jarkko.sakkinen@intel.com> wrote:
>> IOCTL call for /smack/load that takes access rule in
>> the same format as they are written into /smack/load.
>> Sets errno to zero if access is allowed and to EACCES
>> if not.
>>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
> [SELinux maintainer here, but Casey knew to already take what I say
> with a grain of salt]

Indeed.

> I'm not telling you to do anything differently, just telling you what
> SELinux does, and why we do it.  SELinux has a file in selinuxfs
> called 'access.'  The file can be opened and one can write a rule into
> the file.  One then calls read and gets back a structure which
> contains all of the permissions information allowed for the
> source/target/class.

Is that really how it works? The code reads as if the buffer
passed by write gets modified in place and the writer is expected
to use that. There is nothing in the code that looks like the
response is getting set aside for a subsequent read. If it works
the way you say it does it will be subject to races up the wazoo.
If it works the way I think the code says it does it is abusive
of the write interface.

> In SELinux we calculate all of the permissions
> for the tuple at once so providing all of the information at once can
> make a lot of sense.  libselinux provides libraries that will cache
> these decisions in the userspace program and quickly answer the same
> (or similar) questions later.

I have played with similar code for Smack and it works just fine
if you're willing to ignore rule updates and schlep all the rule
lists around in user space on the off chance someone will make an
access check. Smack is intentionally kernel oriented (hence the
"k" and the end of the name) and the ioctl requires much less
user space support than the /selinux/accesss interface, should it
be a write+read interface or an abused write.

> http://userspace.selinuxproject.org/trac/browser/libselinux/src/compute_av.c
>
> Shows the userspace side of out "access" interface.  Your interface is
> good in that it only takes 1 syscall and ours takes 2.  Your interface
> is bad in that it is ioctl and we are told since birth that we must
> hate them no matter what (not that read/write is really any
> different).  It isn't the same method the only other LSM I know about
> uses.  It can only every return one value (ok, I know ioctl can be
> made to do anything at all)

Much better to use an ioctl for a query interface than to jump
through hoops with unnatural uses of other interfaces.

And just as a note, I was working with UNIX when ioctl was
introduced and I didn't like it then. I would not be considering
an ioctl interface if it where not the correct way to solve the
problem.


> Anyway, just food for thought....
>
> -Eric
>

