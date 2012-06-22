Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232Ab2FVOVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 10:21:39 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:46154 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762132Ab2FVOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 10:21:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>, Marcel Holtmann <marcel@holtmann.org>,
        Doug Ledford <dledford@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20120622000049.GA7877@www.outflux.net>
Date: Fri, 22 Jun 2012 07:21:21 -0700
In-Reply-To: <20120622000049.GA7877@www.outflux.net> (Kees Cook's message of
	"Thu, 21 Jun 2012 17:00:49 -0700")
Message-ID: <87ipejo2am.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/roZNSRLpWgjz0HkzNIdq+RHWMB6C7tlk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] fs: introduce pipe-only dump mode suid_dumpable=3
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> This patch introduces suid_dumpable=3 to allow privilege-changed processes
> to be dumped only to a pipe handler (and not directly to disk). The value
> of suid_dumpable=2 is now deprecated, and attempting to set this sysctl
> value returns -EINVAL.

Your patch descriptoin is wrong.  Deprecate means something is encouraged
not to be used not that the functionality is removed.  I think what
you are trying to say is that the value suid_dumpable=2 is now historic.

Your implementation is absolutely gross.  Reading the value from
twice from user space??    Is an if statement that hard to code?

Eric

> +/* Allow only the integers 0, 1, and 3. */
> +static int proc_dointvec_suid_dumpable(struct ctl_table *table, int write,
> +		void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	int rc, min, max;
> +	struct do_proc_dointvec_minmax_conv_param param = {
> +		.min = &min,
> +		.max = &max,
> +	};
> +
> +	min = 0;
> +	max = 1;
> +	rc = do_proc_dointvec(table, write, buffer, lenp, ppos,
> +			      do_proc_dointvec_minmax_conv, &param);
> +	if (rc != -EINVAL)
> +		return rc;
> +
> +	min = 3;
> +	max = 3;
> +	rc = do_proc_dointvec(table, write, buffer, lenp, ppos,
> +			      do_proc_dointvec_minmax_conv, &param);
> +	return rc;
> +}
> +
>  static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int write,
>  				     void __user *buffer,
>  				     size_t *lenp, loff_t *ppos,
