Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665Ab1DOPV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:21:58 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53112 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab1DOPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:20:52 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 0/4] MCE, EDAC: HW MCE injection
Date: Fri, 15 Apr 2011 17:20:23 +0200
Message-Id: <1302880827-22457-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

here's a patchset that provides the ability to inject MCEs in hardware
on AMD by writing directly into MCA registers and calling the #MC
exception handler. This allows more thorough testing of MCE core, EDAC
and RAS code in general (oh yeah, or you can simply play with it).

Here's how to do that:

1. Make sure to set (debugfs-mnt-point)/mce/fake_panic to 1 otherwise your
machine will panic

2. Enable the /sysfs injection module in the kernel: CONFIG_EDAC_MCE_INJ
and load it.

3. Use the following rough python script like so:

./mcegen.py -u dc -i=hw

This will generate an almost random Data Cache (u selects the CPU
functional unit to generate MCEs for) MCE and inject it. I know, the
script needs a bunch of cleaning and fixing but all in good time, as
they say.

Comments/rants/questions are welcome, as always.

Thanks.

--
#!/usr/bin/python

import sys
import inspect
from random import *
from optparse import OptionParser

eecs = ['ECC/Resv', 'CRC', 'Sync', 'Mst Abort', 'Tgt Abort',                         #0-4
        'GART', 'RMW', 'WDT', 'ECC', 'DEV', 'Link Data',                             #5-10
        'Protocol', 'NB Array', 'DRAM Parity', 'Link Retry',                         #11-14
        'GART/DEV Table Walk', 'Resv', 'Resv', 'Resv', 'Resv', 'Resv',               #15-20
        'Resv', 'Resv', 'Resv', 'Resv', 'Resv', 'Resv',                              #21-26
        'Resv', 'L3 Cache Data', 'L3 Cache Tag', 'L3 Cache LRU', 'Probe Filter']     #27-31

r4s = ['GEN', 'RD', 'WR', 'DRD', 'DWR', 'IRD', 'PRF', 'EV', 'SNP']
lls = ['RESV', 'L1', 'L2', 'LG' ]
iis = ['MEM', 'RESV', 'IO', 'GEN' ]
tts = ['INSN', 'DATA', 'GEN', 'RESV' ]
pps = ['SRC', 'RES', 'OBS', 'GEN' ]

fus = {'DC': 0, 'IC': 1, 'BU': 2, 'CU': 2, 'LS': 3, 'NB': 4, 'FR': 5, 'EX': 5, 'FP': 6}
error_types = ['TLB', 'MEM', 'BUS']

families = ['k8', 'f10h', 'f11h', 'f12h', 'f14h', 'f15h']

def bit(b):
    if b < 0 or b > 63:
        return 0
    return 1L << b

class MCE(object):
    """ Class representing a Machine Check Exception signature
    """

    value    = 0
    syndrome = 0
    fu       = 'DC'  # DC MCE by default
    err_type = 'BUS'

    def __init__(self, val=0, fu='DC', err_type='BUS'):
        self.err_type = err_type
        self.fu = fu

        if val:
            self.value = val
        else:
            self.gen_mce()


    def eec(self, mce=None):
        if mce:
            return (mce >> 16) & 0x1f

        return (self.value >> 16) & 0x1f

    def __is_ecc(self, mce=None):
        return self.eec(mce) == 0x8

    def _sanitize_error_type(self, mce):
        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce &= 0xffffffffffff001f
        # MEM
        elif ec & bit(8):
            mce &= 0xffffffffffff01ffL
            # RRRR is max 8
            if mce & bit(7):
                mce &= ~(0x7 << 4)
        # BUS
        elif ec & bit(11):
            mce &= 0xffffffffffff0fffL
            # RRRR is max 8
            if mce & bit(7):
                mce &= ~(0x7 << 4)

        else:
            # fallback to a BUS error (those are most common: DRAM ECC)
            mce &= 0xffffffffffff0fffL
            mce |= bit(11)

        return mce

    def __prep_TLB(self, mce):
        # cleanup fields first
        mce &= 0xffffffffffe00010L

        # ErrorCodeExt[19:16] selects between TLB error types
        # BD introduces a locked TLB miss with EEC=0x2
        eec = randint(0,2)

        return mce | eec << 16

    def __prep_MEM(self, mce):
        # cleanup fields
        mce &= 0xffffffffffe00100L

        return mce

    def __prep_BUS(self, mce):
        # cleanup bytes first
        mce &= 0xffffffffffe00800L

        return mce


    def __gen_dc_mce(self, mce):
        """ Generate a DC MCE signature. Some of the fields are overlapping and
            not valid for all families but this is ok since we want to check the
            error path too when generating an invalid MCE or the MCi_STATUS
            somehow got corrupted
        """

        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            ll  = lls.index(choice(['L1' , 'L2']))

            mce |= 0x1 << 2 | ll  # TT=Data

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            # BD introduces a bunch of EECs != 0
            eec = choice(range(0, 4) + range(16, 20))
            r4  = r4s.index(choice(['GEN', 'DRD', 'DWR', 'EV', 'SNP']))
            ll  = lls.index(choice(['LG', 'L1' , 'L2']))

            mce |= eec << 16 | r4 << 4 | 0x1 << 2 | ll  # TT=Data

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            eec = randint(0, 2)
            pp  = pps.index(choice(['SRC', 'GEN']))
            r4  = r4s.index(choice(['GEN', 'RD', 'DRD', 'DWR']))
            ii  = iis.index(choice(['MEM', 'IO', 'GEN']))

            mce |= eec << 16 | pp << 9 | randint(0, 1) << 8 | r4 << 4 | ii << 2 | 0x3  # LL=LG

        return mce

    def __gen_ic_mce(self, mce):
        """ Generate an IC MCE signature.
        """

        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)
            mce |= lls.index(choice(['L1' , 'L2'])) # TT=Instr, already 0

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = choice(range(0, 11) + [13] + range(16, 21))
            r4  = r4s.index(choice(['IRD', 'SNP', 'EV']))
            ll  = lls.index(choice(['L1' , 'L2', 'LG']))

            mce |= eec << 16 | r4 << 4 | ll # TT=Instr

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            # eec,pp,t,ii already 0
            # IRD, 5
            mce |= 5 << 4 | 3

        return mce


    def __gen_bu_mce(self, mce):
        """ Generate an BU MCE signature
            F12h has all three types based on ErrorCode: TLB, MEM and BUS

        """

        ec = mce & 0xffff
        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            tt = tts.index(choice(['INSN', 'DATA']))

            mce |= tt << 2 | 0x1 # LL=L1

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = randint(0, 3)
            r4 = r4s.index(choice(['GEN', 'RD', 'WR', 'DRD', 'IRD', 'EV', 'SNP']))
            tt = tts.index(choice(['GEN', 'INSN', 'DATA']))
            ll = lls.index(choice(['LG' , 'L2']))

            mce |= eec << 16 | r4 << 4 | tt << 2 | ll

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            r4 = r4s.index(choice(['RD', 'PRF']))
            ii = iis.index(choice(['MEM', 'IO']))

            mce |= r4 << 4 | ii << 2 | 0x3 # LL=LG


        return mce



    def __gen_cu_mce(self, mce):
        """ Generate an OR Combined Unit MCE
        """

        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            mce |= 0x2 << 2 | 0x2 # TT=GEN, LL=L2

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = choice(range(4, 13) + range(16, 21))
            r4  = r4s.index(choice(['DRD', 'IRD', 'PRF' 'DWR', 'SNP', 'EV', 'GEN']))
            tt  = tts.index(choice(['GEN', 'INSN', 'DATA']))
            ll  = lls.index(choice(['LG' , 'L1', 'L2']))

            mce |= eec << 16 | r4 << 4 | tt << 2 | ll

        # BUS
        elif ec & bit(11):
            mce = self.__prep_BUS(mce)

            eec = randint(0, 2)
            r4  = r4s.index(choice(['RD', 'DWR']))
            ii  = iis.index(choice(['MEM', 'IO']))
            ll  = lls.index(choice(['L1', 'L2']))

            mce |= eec << 16 | r4 << 4 | ii << 2 | ll # PP=SRC, T=0

        return mce


    def __gen_ls_mce(self, mce):
        """ Generate an LS MCE signature
        """

        # LS MCEs are only of type BUS so set bit 11
        mce |= bit(11)

        mce = self.__prep_BUS(mce)
        r4 = r4s.index(choice(['DRD', 'DWR']))
        ii = iis.index(choice(['MEM', 'IO']))

        mce |= r4 << 4 | ii << 2 | 0x3 # LL=LG

        return mce


    def __gen_nb_mce(self, mce):
        """ Generate an NB MCE signature
        """
        ec = mce & 0xffff

        # TLB
        if ec & bit(4):
            mce = self.__prep_TLB(mce)

            eec = choice([5, 15]) # GART Err, GART TLB Walk Data Err

            mce |= eec << 16 | 0x2 << 2 | 0x3 # GEN, LG

        # MEM
        elif ec & bit(8):
            mce = self.__prep_MEM(mce)

            eec = choice([25, 28, 29, 30, 31])
            r4  = r4s.index(choice(['GEN', 'RD', 'WR', 'EV', 'SNP']))
            tt  = tts.index(choice(['GEN', 'DATA']))

            mce |= eec << 16 | r4 << 4 | tt << 2 | 0x3 # LG

        # BUS
        elif ec & 0x0080:
            mce = self.__prep_BUS(mce)

            eec = choice(range(1, 5) + range(6, 16))
            pp  = pps.index(choice(pps))    # yes, all 4 are possible
            r4  = r4s.index(choice(['GEN', 'RD', 'WR', 'DWR']))
            ii  = iis.index(choice(['MEM', 'IO', 'GEN']))

            mce |= eec << 16 | pp << 9 | randint(0, 1) << 8 | r4 << 4 | ii << 2 | 0x3 # LL=LG

        return mce


    def __gen_fr_mce(self, mce):
        """ Generate a FR MCE signature
        """

        # FR/EX MCEs are only of type BUS so set bit 11
        mce |= bit(11)

        # BD-specific
        eec = randint(0, 12)

        mce = self.__prep_BUS(mce)
        mce |= eec << 16 | 0x3 << 9 | randint(0,1) << 8 | 0x3 << 2 | 0x3 # PP=GEN, R4=GEN, II=GEN, LL=LG

        return mce


    def gen_mce(self):
        mce     = getrandbits(64)

        # remove reserved stuff, along with clearing syndrome bits[54:47,31:24]
        mce &= 0xfe006100000fffff

        # Valid
        mce |= bit(63)

        # set CECC, UECC according to bit 61, UC: error couldn't be corrected by hw
        if mce & bit(61):
            mce &= ~bit(46)
            mce |= bit(45)
        else:
            mce |= bit(46)
            mce &= ~bit(45)

        # EN should be always set, otherwise moot
        mce |= bit(60)

        if self.err_type:
            # Clear error type bits so that later we don't get confused
            mce &= 0xfffffffffffff6ef

            if self.err_type == 'TLB':
                mce |= bit(4)
            elif self.err_type == 'MEM':
                mce |= bit(8)
            else:
                mce |= bit(11)

        if self.__is_ecc(mce):
            syndrome = getrandbits(16)
            mce |= ((syndrome & 0x0f) << 47)
            mce |= ((syndrome & 0xf0) << 20)
            self.syndrome = syndrome

        if self.fu == 'DC':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_dc_mce(mce)
        elif self.fu == 'IC':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_ic_mce(mce)
        elif self.fu == 'BU':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_bu_mce(mce)
        elif self.fu == 'CU':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_cu_mce(mce)
        elif self.fu == 'LS':
            mce = self.__gen_ls_mce(mce)
        elif self.fu == 'NB':
            mce = self._sanitize_error_type(mce)
            mce = self.__gen_nb_mce(mce)
        elif self.fu == 'FR' or self.fu == 'EX' or self.fu == 'FP':
            mce = self.__gen_fr_mce(mce)

        self.value = mce

    def __is_bit_set(self, bit):
        if bit < 0 or bit > 63:
            return False
        if self.value & (1 << bit):
            return True

        return False

    def valid(self):        return self.__is_bit_set(63)
    def overflow(self):     return self.__is_bit_set(62)
    def uncorrected(self):  return self.__is_bit_set(61)
    def err_enabled(self):  return self.__is_bit_set(60)
    def miscv(self):        return self.__is_bit_set(59)
    def addrv(self):        return self.__is_bit_set(58)
    def pcc(self):          return self.__is_bit_set(57)
    def cecc(self):         return self.__is_bit_set(46)
    def uecc(self):         return self.__is_bit_set(45)
    def scrub(self):        return self.__is_bit_set(40)

    def decode_eec(self):
        return eecs[self.eec()]

    def decode_tt(self):    return tts[(self.value >> 2) & 0x3]
    def decode_ll(self):    return lls[self.value & 0x3]
    def decode_pp(self):    return pps[(self.value >> 9) & 0x3]
    def decode_ii(self):    return iis[(self.value >> 2) & 0x3]

    def decode_r4(self):
        r4 = (self.value >> 4) & 0xf

        if r4 > 8:
            return "-"

        return r4s[r4]

    def decode_t(self):
        t = (self.value >> 8) & 0x1

        if t:
            return "TIMOUT"
        return "NOTIMOUT"

    def error_type(self):
        ec = self.value & 0xffff

        if   (ec & 0xfff0) == bit(4):
            return "TLB(tt:" + self.decode_tt() + ";ll:" + self.decode_ll() + ")"
        elif (ec & 0xff00) == bit(8):
            return "MEM(r4:" + self.decode_r4() + ";tt:" + self.decode_tt() + \
                   ";ll:" + self.decode_ll() + ")"
        elif (ec & 0xF800) == bit(11):
            return "BUS(pp:" + self.decode_pp() + ";t:" + self.decode_t() + \
                   ";r4:"    + self.decode_r4() + ";ii:" + self.decode_ii() + \
                   ";ll:"    + self.decode_ll() + ")"
        else:
            return "WTF?!"

    def __repr__(self):
        ret = []

        if self.valid():        ret.append("Val")
        if self.overflow():     ret.append("Over")
        if self.uncorrected():  ret.append("UC")
        if self.err_enabled():  ret.append("EN")
        if self.miscv():        ret.append("MiscV")
        if self.addrv():        ret.append("AddrV")
        if self.pcc():          ret.append("PCC")
        if self.cecc():         ret.append("CECC")
        if self.uecc():         ret.append("UECC")
        if self.scrub():        ret.append("Scrub")

        dec_bits = '|'.join(ret)

        dec_bits += "|EEC: " + self.decode_eec() + (" (0x%02x)" % (self.eec()))

        if self.__is_ecc():
            dec_bits += (" (synd=0x%04x)" % (self.syndrome))

        dec_bits += "|ET: " + self.error_type()

        return ("MC%d_STATUS[%s]: 0x%016x" % (fus[self.fu], dec_bits, self.value))

def inject_mce(mce, fu, hw_inj=False):
    """ Injects and MCE error over EDAC's /sysfs
    """

    sysfs_prefix = '/sys/devices/system/edac/mce'

    mce_status_file = sysfs_prefix + '/status'
    mce_bank_file   = sysfs_prefix + '/bank'

    try:
        status_f = open(mce_status_file, 'r+')
    except:
        print "Cannot open %s" % (mce_status_file)
        print "Have you forgotten modprobing mce_amd_inj.ko?"
        return

    try:
        bank_f = open(mce_bank_file, 'r+')
    except:
        print "Cannot open %s" % (mce_bank_file)
        if status_f:
            status_f.close()
        return

    if hw_inj:
        mce_hw_inject_file = sysfs_prefix + '/hw_inject'

        try:
            hw_f = open(mce_hw_inject_file, 'r+')
        except:
            print "Cannot open %s" % (mce_hw_inject_file)
            if status_f:
                status_f.close()
            if bank_f:
                bank_f.close()

        hw_f.write('1')
        hw_f.close()


    status_f.write(("0x%016x" % (mce.value)))
    bank_f.write(("%d" % (fus[fu])))

    status_f.close()
    bank_f.close()


def init_parser():
    """ Read cmdline options

        returns:
        options:dict -- config options
    """

    parser = OptionParser()

    parser.add_option(
            "-d",
            "--decode",
            type="string",
            action="store",
            dest="d",
            help="Decode 64-bit MCi_STATUS value representing an MCE"
    )

    def fam_callback(option, opt_str, value, parser):

        if value == 'R':
            parser.values.f = choice(families)
        elif value in families:
            parser.values.f = value
        else:
            # generate F10h MCEs per default
            parser.values.f = 'f10h'

    parser.add_option(
            "-f",
            "--family",
            dest="f",
            type="string",
            action="callback",
            callback=fam_callback,
            help=("Family to generate MCE for %s" % (families))
    )

    parser.add_option(
            "-i",
            "--inject",
            dest="i",
            type="string",
            help="Inject the error, 'hw' for hardware MCE injection, 'sw' for software-only"
    )

    def et_callback(option, opt_str, value, parser):

        value = value.upper()

        if value not in error_types:
            sys.stderr.write(("WARNING: wrong error type: %s\n" % (value)))

        parser.values.et = value

    parser.add_option(
            "-t",
            "--error-type",
            dest="et",
            type="string",
            action="callback",
            callback=et_callback,
            help=("Generate a specific error type: %s" % (error_types))
    )

    def fu_callback(option, opt_str, value, parser):

        # supplied string could be lowercase
        value = value.upper()

        # randomize FUs
        if value == 'R':
            # don't generate FP MCE yet
            k = fus.keys()
            k.remove('FP')
            parser.values.fu = choice(k)
        elif value in fus.keys():
            parser.values.fu = value

    parser.add_option(
            "-u",
            "--functional-unit",
            dest="fu",
            type="string",
            action="callback",
            callback=fu_callback,
            help=("Functional unit to generate MCE for %s" % (fus.keys())),
    )

    options = parser.parse_args()[0]
    return options

def main():

    options = init_parser()

    if options.d:
        if options.fu:
            m = MCE(val=int(options.d, 16), fu=options.fu)
            print m
        else:
            sys.stderr.write("You need to supply the functional unit this signature belongs to.\n")
            sys.exit(-1)
    else:
        if not options.fu:
            options.fu = choice(fus.keys())
            print "Selecting FU at random:", options.fu

        m = MCE(fu=options.fu, err_type=options.et)
        sys.stderr.write(("Generating an %s MCE:\n%s\n" % (options.fu, m)))

    if options.i:
        if options.i == 'hw':
            inject_mce(m, options.fu, True)
        else:
            inject_mce(m, options.fu)

if __name__ == "__main__":
    main()
