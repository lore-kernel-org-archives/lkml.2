Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795Ab2BCBbU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 20:31:20 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38263 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab2BCBbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 20:31:18 -0500
X-Originating-IP: 217.70.178.130
X-Originating-IP: 50.43.15.19
Date: Thu, 2 Feb 2012 17:31:08 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] checkpatch: Check for quoted strings broken across lines
Message-ID: <20120203013108.GA13456@leaf>
References: <20120202200621.GB9279@leaf>
 <20120202202207.GA10041@elliptictech.com>
 <20120202211638.GA11308@leaf>
 <20120202220853.GA13723@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20120202220853.GA13723@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 05:08:53PM -0500, Nick Bowler wrote:
> On 2012-02-02 13:16 -0800, Josh Triplett wrote:
> > On Thu, Feb 02, 2012 at 03:22:07PM -0500, Nick Bowler wrote:
> > > On 2012-02-02 12:06 -0800, Josh Triplett wrote:
> > > > Documentation/CodingStyle recommends not splitting quoted strings across
> > > > lines, because it breaks the ability to grep for the string.  checkpatch
> > > > already makes an exception to the 80-column rule for quoted strings to
> > > > allow this.  Rather than just allowing it, actively warn about quoted
> > > > strings split across lines.
> > > [...]
> > > > +# Check for strings broken across lines (breaks greppability).  Make an
> > > > +# exception when the previous string ends in a newline (multiple lines in one
> > > > +# string constant) or \n\t (common in inline assembly to indent the instruction
> > > > +# on the following line).
> > > 
> > > There are tons of strings in the kernel that this makes checkpatch warn
> > > about where it probably shouldn't.  For example, this one (from
> > > kernel/auditsc.c:1476):
> > > 
> > >   		audit_log_format(ab,
> > >   			"oflag=0x%x mode=%#ho mq_flags=0x%lx mq_maxmsg=%ld "
> > >   			"mq_msgsize=%ld mq_curmsgs=%ld",
> > > 
> > >   WARNING: quoted string split across lines
> > >   #1478: FILE: auditsc.c:1478:
> > >   +			"mq_msgsize=%ld mq_curmsgs=%ld",
> > > 
> > > Breaking "greppability" of this string is a non-issue, because this sort
> > > of string is not really greppable to begin with (and would certainly not
> > > be any easier to grep for if it were all on one line).
> > 
> > While I agree that in that particular case (heavy on the %formats and
> > light on the text) you can't easily grep to begin with, the guideline
> > from CodingStyle still applies,
> 
> The guideline from CodingStyle talks about "user-visible strings".  I
> don't think this string counts, because it contains code that is not
> displayed to the user (hence, the string is not user-visible).  That is
> the reason why it's not greppable in the first place.
> 
> There are hundreds, if not thousands of similar strings in the kernel.

OK, with a combination of arcane grep/sed commands and hand checking, I
just scanned the *entire* kernel for quoted strings split across lines,
and filtered out all user-visible strings, leaving only the split
non-user-visible strings.

An excerpt from that pile of ugly, suggesting just how many ways kernel
code has to spell "user-visible":

\(print[a-z_]*\|pr_[a-z]*\|pr_[a-z]*_ratelimited\|pr_debug[0-9]\|pr_info_once\|dev_[a-z]*\|msg\|warn\|warn_once\|dbg\|debug\|debugp\|err\|error\|errdev\|errx\|warning\|DBG[A-Z0-9_]*\|DEBUG[A-Z_]*\|trace[a-z0-9_]*\|LOG_KMS\|exception\|FAIL\|fatal\|assert\|panic_vm\|trace\|panic\|puts\|MODULE_[A-Z_]*\|asm\|__asm__\|volatile\|__volatile__\|message\|log\|info\|DAC960_[A-Za-z_]*\|notify\|ufsd\|crit\|debugf[0-9]\|DP\|die\|fyi\|notice\|dout\|snoop\|throtl_log_tg\|ERROR_INODE\|RFALSE\|DMESGE\|SAY\|JOM\|SAM\|JOT\|DBF_EVENT\|DE_ACT\|s390_handle_damage\|CIO_MSG_EVENT\|CIO_CRW_EVENT\|DBF_EVENT_DEVID\|fat_fs_error_ratelimit\|mark_tsc_unstable\|ata_ehi_push_desc\|DEB[0-9]\|IUCV_DBF_TEXT_\|LOG_PARSE\|esp_log_[a-z]*\|check_warn_return\|D_ISR\|D_CALIB\|D_RATE\|D_TX_REPLY\|D_TXPOWER\|D_EEPROM\|D_POWER\|D_SCAN\|D_ASSOC\|D_HC\|D_HC_DUMP\|IP_VS_ERR_BUF\|DMWARN_LIMIT\|ide_dump_status\|ppfinit\|mca_recovered\|die_if_kernel\|die_if_no_fixup\|gdbstub_proto\|ite_pr\|nvt_pr\|deb_i2c\|deb_irq\|deb_ts\|deb_rc\|mxl_i2c\|MLX4_EN_PARM_INT\|DI\|d_fnstart\|d_fnend\|lbs_deb_[a-z_]*\|LPFC_[A-Z_]*\|stop\|mconsole_reply_v0\|CH_ALERT\|D1\|ADD\|lbtf_deb_usbd\|IWL_DEBUG_MAC80211\|WL_CONN\|CX18_INFO_DEV\|CX18_ERR_DEV\|OPT_BOOLEAN\|asc_prt_line\|gdbstub_msg_write\|DCCP_BUG\|fappend\)

I found that a single change to my checkpatch test (only checking
strings passed as function arguments) limits the false positives in the
entire kernel to a grand total of 12:

arch/powerpc/platforms/iseries/mf.c:    memcpy(src, "\x01\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00"
arch/um/os-Linux/process.c:     if (sscanf(buf, "%*d " COMM_SCANF " %*c %*d %*d %*d %*d %*d %*d %*d "
arch/x86/platform/olpc/olpc_dt.c:       olpc_dt_interpret("\" /battery@0\" find-device"
arch/x86/platform/olpc/olpc_dt.c:               olpc_dt_interpret("\" /pci/display@1\" find-device"
arch/x86/platform/olpc/olpc_dt.c:               olpc_dt_interpret("\" /pci/display@1,1\" find-device"
drivers/block/rbd.c:               "%" __stringify(RBD_MAX_OBJ_NAME_LEN) "s"
drivers/pcmcia/ds.c:    if (add_uevent_var(env, "MODALIAS=pcmcia:m%04Xc%04Xf%02Xfn%02Xpfn%02X"
drivers/tty/tty_audit.c:                audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u "
fs/ecryptfs/crypto.c:static unsigned char *portable_filename_chars = ("-.0123456789ABCD"
kernel/auditsc.c:               audit_log_format(ab, " inode=%lu"
kernel/auditsc.c:                       audit_log_format(ab, "login pid=%d uid=%u "
security/selinux/ss/services.c: audit_log_format(ab, "op=security_compute_av reason=%s "

Not "hundreds, if not thousands", but 12, including 4 calls to
audit_log_format. :)

Meanwhile, this checkpatch test correctly flags several thousand
instances of user-visible strings that shouldn't get split.  That seems
like a pretty reasonable ratio to me; what do you think?

I'll send PATCHv2, which limits the check to function parameters,
momentarily.

- Josh Triplett
